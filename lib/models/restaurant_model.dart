class Specialty {
  final String name;
  final String price;

  const Specialty({required this.name, required this.price});
}

class Review {
  final String userName;
  final String comment;
  final double rating;
  final String date;

  const Review({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final String location;
  final double rating;
  final String distance;
  final String category;
  final bool isFavorite;
  final String openingHours;
  final List<Specialty> specialties;
  final String phone;
  
  // New Fields
  final double latitude;
  final double longitude;
  final List<String> mealTypes; // e.g. ["Petit-déjeuner", "Déjeuner"]
  final List<Review> reviews;

  const Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.rating,
    required this.distance,
    required this.category,
    required this.isFavorite,
    required this.openingHours,
    required this.specialties,
    required this.phone,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.mealTypes = const [],
    this.reviews = const [],
  });

  Restaurant copyWith({
    String? id,
    String? name,
    String? image,
    String? location,
    double? rating,
    String? distance,
    String? category,
    bool? isFavorite,
    String? openingHours,
    List<Specialty>? specialties,
    String? phone,
    double? latitude,
    double? longitude,
    List<String>? mealTypes,
    List<Review>? reviews,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        location: location ?? this.location,
        rating: rating ?? this.rating,
        distance: distance ?? this.distance,
        category: category ?? this.category,
        isFavorite: isFavorite ?? this.isFavorite,
        openingHours: openingHours ?? this.openingHours,
        specialties: specialties ?? this.specialties,
        phone: phone ?? this.phone,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        mealTypes: mealTypes ?? this.mealTypes,
        reviews: reviews ?? this.reviews,
      );
}
