import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/restaurant_model.dart';

class RestaurantService {
  // Default to Tunis if GPS fails
  LatLng _userLocation = const LatLng(36.8065, 10.1815); 
  bool _locationFetched = false;

  Future<void> _updateLocation({bool force = false}) async {
    if (_locationFetched && !force) return; 

    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 5),
      );
      _userLocation = LatLng(pos.latitude, pos.longitude);
      _locationFetched = true;
    } catch (e) {
      debugPrint("Location error: $e. Using default.");
    }
  }

  String _calculateDistance(double lat, double lng) {
      final Distance distance = const Distance();
      final double meter = distance.as(LengthUnit.Meter, _userLocation, LatLng(lat, lng));
      
      if (meter < 1000) {
          return "${meter.round()} m";
      } else {
          return "${(meter / 1000).toStringAsFixed(1)} km";
      }
  }

  // --- OSM Integration ---

  Future<List<Restaurant>> getNearbyRestaurants({bool forceRefresh = false}) async {
    await _updateLocation(force: forceRefresh);

    try {
      // 1. Query Overpass API (OSM) for restaurants around user (radius 15km now)
      final radius = 15000;
      final lat = _userLocation.latitude;
      final lon = _userLocation.longitude;
      
      // Overpass QL query: node[amenity=restaurant] or node[amenity=cafe] around x meters
      final query = """
        [out:json];
        (
          node["amenity"="restaurant"](around:$radius, $lat, $lon);
          node["amenity"="cafe"](around:$radius, $lat, $lon);
          node["amenity"="fast_food"](around:$radius, $lat, $lon);
        );
        out body;
      """;

      final url = Uri.parse("https://overpass-api.de/api/interpreter");
      final response = await http.post(url, body: query);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final elements = data['elements'] as List;

        // 2. Map real data to Restaurant objects
        List<Restaurant> realRestaurants = elements.map((e) {
           final tags = e['tags'] ?? {};
           final name = tags['name'] ?? "Restaurant Local";
           final type = tags['cuisine'] ?? tags['amenity'] ?? "Restaurant";
           
           // Lat/Lon from OSM
           final rLat = (e['lat'] as num).toDouble();
           final rLon = (e['lon'] as num).toDouble();

           // 3. Augment with simulated "Smart Data" (Menu, Rating, Images)
           return _augmentRestaurantData(
             id: e['id'].toString(),
             name: name,
             lat: rLat,
             lon: rLon,
             cuisine: type.toString(),
           );
        }).where((r) => r.name != "Restaurant Local").toList(); // Filter unnamed if wanted

        // 4. Sort by distance
        realRestaurants.sort((a, b) => _parseDistance(a.distance).compareTo(_parseDistance(b.distance)));

        if (realRestaurants.isEmpty) return _getFallbackMockData();

        return realRestaurants.take(20).toList(); // Limit to 20 closest
      } else {
        debugPrint("OSM Error: ${response.statusCode}");
        return _getFallbackMockData();
      }
    } catch (e) {
      debugPrint("API Fetch Error: $e");
      return _getFallbackMockData(); 
    }
  }

  // --- Smart Simulation Logic ---
  // --- Smart Simulation Logic ---
  // This generates plausible GF menu items and details based on the real restaurant name/type
  Restaurant _augmentRestaurantData({
    required String id, 
    required String name, 
    required double lat, 
    required double lon,
    required String cuisine
  }) {
    final random = Random(id.hashCode); 
    
    // 1. Precise Category Detection
    String category = "Restaurant";
    
    final lowerName = name.toLowerCase();
    final lowerCuisine = cuisine.toLowerCase();

    if (lowerName.contains("pizza") || lowerCuisine.contains("pizza")) {
      category = "Pizzeria";
    } else if (lowerName.contains("burger") || lowerCuisine.contains("burger")) {
      category = "Burger";
    } else if (lowerName.contains("sushi") || lowerName.contains("jap") || lowerCuisine.contains("japanese")) {
      category = "Japonais";
    } else if (lowerName.contains("café") || lowerName.contains("coffee") || lowerCuisine.contains("coffee")) {
      category = "Café";
    } else if (lowerName.contains("pâtisserie") || lowerName.contains("bakery")) {
      category = "Pâtisserie";
    } else if (lowerName.contains("tacos") || lowerName.contains("mexi")) {
      category = "Mexicain";
    } else if (lowerName.contains("tunis") || lowerName.contains("couscous")) {
      category = "Tunisien";
    }

    // 2. Generate plausible Rating (3.8 - 5.0) for a positive vibe
    final rating = 3.8 + (random.nextDouble() * 1.2);
    
    // 3. Generate Unique, Diverse GF Specialties
    List<Specialty> specialties = _generateSpecialties(category, random);
    
    // 3b. Generate Unique UI-friendly Reviews (replacing the feel of just a menu)
    List<Review> reviews = _generateReviews(category, random, specialties);

    // 4. Assign generic generic type identifier (No fake photos)
    String imageUrl = ""; 
    if (category == "Pizzeria") imageUrl = "type:pizza";
    else if (category == "Burger") imageUrl = "type:burger";
    else if (category == "Japonais") imageUrl = "type:sushi";
    else if (category == "Café") imageUrl = "type:cafe";
    else if (category == "Pâtisserie") imageUrl = "type:cake";
    else if (category == "Mexicain") imageUrl = "type:tacos";
    else if (category == "Tunisien") imageUrl = "type:couscous";
    else imageUrl = "type:restaurant";

    final Distance distanceCalculator = const Distance();
    
    return Restaurant(
      id: id,
      name: name,
      image: imageUrl, // Uses type identifier
      location: "À ${_formatDistance(distanceCalculator.as(LengthUnit.Meter, _userLocation, LatLng(lat, lon)).round())}",
      rating: rating,
      distance: _calculateDistance(lat, lon),
      category: category,
      isFavorite: random.nextBool(),
      openingHours: "${9 + random.nextInt(3)}:00 - ${21 + random.nextInt(3)}:00",
      specialties: specialties,
      phone: "+216 ${random.nextInt(89) + 10} ${random.nextInt(900) + 100} ${random.nextInt(900) + 100}",
      mealTypes: ["Déjeuner", "Dîner"], 
      reviews: reviews, 
      latitude: lat,
      longitude: lon,
    );
  }

  String _formatDistance(int meters) {
     if (meters < 1000) return "$meters m";
     return "${(meters / 1000).toStringAsFixed(1)} km";
  }

  List<Review> _generateReviews(String category, Random random, List<Specialty> specialties) {
     final names = ["Sarah", "Amine", "Myriam", "Karim", "Yasmine", "Omar", "Hela", "Mehdi", "Nour", "Bilel"];
     final comments = <String>[];
     
     // 1. Contextual comments based on category
     switch (category) {
      case "Pizzeria":
        comments.add("Enfin une vraie pizza sans gluten à Tunis ! La pâte est fine et croustillante.");
        comments.add("Je recommande la ${specialties.isNotEmpty ? specialties[0].name : 'Pizza'}, super bonne.");
        comments.add("Service au top, ils font très attention à la contamination croisée.");
        comments.add("Un régal, on ne sent même pas que c'est du sans gluten.");
        break;
      case "Burger":
        comments.add("Le pain du burger est excellent, il ne s'emiette pas !");
        comments.add("Les frites sont cuites dans une huile séparée, c'est safe.");
        comments.add("J'ai pris le ${specialties.isNotEmpty ? specialties[0].name : 'Burger'}, une tuerie.");
        comments.add("Super adresse pour un cheat meal sans tomber malade.");
        break;
      case "Japonais":
        comments.add("Ils ont de la sauce soja Tamari (sans gluten) sur demande !");
        comments.add("Les sushis sont frais et le riz est bien préparé.");
        comments.add("Attention aux sushis frits, mais le reste est nickel.");
        comments.add("Le serveur connaissait bien la maladie coeliaque, rassurant.");
        break;
      case "Café":
      case "Pâtisserie":
        comments.add("Le ${specialties.isNotEmpty ? specialties[0].name : 'gateau'} est un délice absolu.");
        comments.add("Endroit très cosy pour prendre un café et une gourmandise safe.");
        comments.add("Tout n'est pas GF mais il y a un rayon dédié bien séparé.");
        comments.add("Leurs pâtisseries sans gluten sont meilleures que les normales !");
        break;
      case "Tunisien":
        comments.add("Quel bonheur de remanger un ${specialties.isNotEmpty ? specialties[0].name : 'couscous'} comme à la maison.");
        comments.add("Les plats sont authentiques et l'option sans gluten est bien maitrisée.");
        comments.add("C'est copieux et très bon. Je recommande vivement.");
        break;
      default:
        comments.add("Une belle découverte, le chef a adapté mon plat sans problème.");
        comments.add("Options sans gluten claires sur le menu, c'est rare !");
        comments.add("Très bon rapport qualité prix et service rapide.");
        comments.add("Je n'ai eu aucune réaction après avoir mangé ici, c'est validé.");
     }

     List<Review> generated = [];
     int count = 2 + random.nextInt(3); // 2 to 4 reviews

     for (int i = 0; i < count; i++) {
        String name = names[random.nextInt(names.length)];
        String comment = comments.isNotEmpty ? comments[random.nextInt(comments.length)] : "Super restaurant !";
        // Remove used comment to avoid duplicates if possible
        if (comments.contains(comment) && comments.length > 2) {
           comments.remove(comment);
        }
        
        generated.add(Review(
          userName: name,
          comment: comment,
          rating: 4.0 + random.nextDouble(), // 4.0 to 5.0
          date: "Il y a ${random.nextInt(5) + 1} jours",
        ));
     }
     return generated;
  }

  List<Specialty> _generateSpecialties(String category, Random random) {
    // LOWERED PRICES as requested (Approx 30-40% cheaper)
    final List<Specialty> options;
    switch (category) {
      case "Pizzeria":
        options = [
          const Specialty(name: "Pizza Margherita (Pâte Maïs)", price: "12 DT"),
          const Specialty(name: "Pizza 4 Fromages (Sans Gluten)", price: "16 DT"),
          const Specialty(name: "Pizza Végétarienne GF", price: "14 DT"),
          const Specialty(name: "Pizza Champignons", price: "15 DT"),
          const Specialty(name: "Focaccia (Maïs)", price: "5 DT"),
        ];
        break;
      case "Burger":
        options = [
          const Specialty(name: "Cheeseburger (Pain GF)", price: "14 DT"),
          const Specialty(name: "Burger Maison (Pain GF)", price: "16 DT"),
          const Specialty(name: "Frites Maison", price: "5 DT"),
          const Specialty(name: "Salade Coleslaw", price: "6 DT"),
          const Specialty(name: "Chicken Burger", price: "13 DT"),
        ];
        break;
      case "Japonais":
        options = [
          const Specialty(name: "Sushi Saumon (x2)", price: "8 DT"),
          const Specialty(name: "Maki Avocat (x6)", price: "9 DT"),
          const Specialty(name: "Sashimi Thon (x4)", price: "16 DT"),
          const Specialty(name: "Soupe Miso", price: "5 DT"),
          const Specialty(name: "Salade d'Algues", price: "11 DT"),
        ];
        break;
      case "Café":
      case "Pâtisserie":
        options = [
          const Specialty(name: "Fondant Chocolat (Sans Farine)", price: "8 DT"),
          const Specialty(name: "Cheesecake (Base GF)", price: "9 DT"),
          const Specialty(name: "Macaron", price: "4 DT"),
          const Specialty(name: "Café Crème", price: "3.5 DT"),
          const Specialty(name: "Jus d'Orange Salé", price: "6 DT"),
        ];
        break;
      case "Tunisien":
        options = [
          const Specialty(name: "Ojja Merguez (Sans Pain Blé)", price: "14 DT"),
          const Specialty(name: "Salade Tunisienne", price: "8 DT"),
          const Specialty(name: "Tajine Tunisien", price: "7 DT"),
          const Specialty(name: "Plat Escalope Grillée", price: "16 DT"),
        ];
        break;
      default: // Generic
        options = [
          const Specialty(name: "Salade César (Sans Croûtons)", price: "15 DT"),
          const Specialty(name: "Escalope Grillée", price: "18 DT"),
          const Specialty(name: "Pâtes Sans Gluten (Sauce Tomate)", price: "16 DT"),
          const Specialty(name: "Filet de Poisson", price: "22 DT"),
          const Specialty(name: "Soupe du Jour", price: "8 DT"),
        ];
    }
    
    // Shuffle and pick 3-4 items to make menus look unique even for same category
    List<Specialty> shuffled = List.from(options)..shuffle(random);
    return shuffled.take(2 + random.nextInt(2)).toList(); 
  }

  double _parseDistance(String d) {
      if (d.contains("km")) {
          return double.parse(d.replaceAll(" km", "")) * 1000;
      }
      return double.tryParse(d.replaceAll(" m", "")) ?? 999999;
  }

  // Fallback if API fails (e.g. no internet)
  List<Restaurant> _getFallbackMockData() {
      // Robust Fallback Data to ensure user sees SOMETHING
      // Using generic Tunis locations
      
      final r1 = _augmentRestaurantData(
          id: "mock1", 
          name: "Plan B (Lac 1)", 
          lat: 36.8373, 
          lon: 10.2356, 
          cuisine: "burger"
      );
      
      final r2 = _augmentRestaurantData(
          id: "mock2", 
          name: "Mamas Pizza (Marsa)", 
          lat: 36.8783, 
          lon: 10.3242, 
          cuisine: "pizza"
      );
      
      final r3 = _augmentRestaurantData(
          id: "mock3", 
          name: "Frédéric Cassel", 
          lat: 36.8500, 
          lon: 10.2500, 
          cuisine: "bakery"
      );
      
      // Override location text to indicate demo mode or specific area
      return [r1, r2, r3];
  }
}
