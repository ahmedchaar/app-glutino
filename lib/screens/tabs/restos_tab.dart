import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/restaurant_model.dart';
import '../../services/auth_service.dart';
import '../../services/restaurant_service.dart';
import '../../services/favorites_service.dart';
import '../../widgets/rating_stars.dart';
import '../restaurant_detail_screen.dart';

class RestosTab extends StatefulWidget {
  const RestosTab({super.key});

  @override
  State<RestosTab> createState() => _RestosTabState();
}

class _RestosTabState extends State<RestosTab> {
  static const bg = Color(0xFFF8F9FA);
  static const textDark = Color(0xFF1E1E1E);
  static const textMuted = Color(0xFF6E6E6E);
  static const border = Color(0xFFEDEDED);
  static const brand = Color(0xFF2ABF9E);

  final _service = RestaurantService();
  final _favorites = FavoritesService();
  final _searchCtrl = TextEditingController();

  String _activeCategory = "Tous";
  bool _showOnlyFavorites = false;
  String? _activeMealType; // Can be null
  
  bool _loading = true;

  List<Restaurant> _restaurants = [];
  
  // Computed property for filtering
  List<Restaurant> get _filteredRestaurants {
      return _restaurants.where((r) {
        final matchesSearch = _matchesSearch(r);
        final matchesFilters = _matchesFilters(r);
        final matchesFavorites = !_showOnlyFavorites || _favorites.isFavorite(r.id);
        return matchesSearch && matchesFilters && matchesFavorites;
      }).toList();
  }

  @override
  void initState() {
    super.initState();
    _favorites.init().then((_) => setState(() {}));
    _load();
    _favorites.addListener(_onFavoritesChange);
  }

  void _onFavoritesChange() {
    if (mounted) setState(() {});
  }

  Future<void> _load({bool force = false}) async {
    setState(() => _loading = true);
    try {
      final results = await _service.getNearbyRestaurants(forceRefresh: force);
      if (mounted) {
        setState(() {
          _restaurants = results;
        });
      }
    } catch (e) {
      debugPrint("Error loading restaurants: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _favorites.removeListener(_onFavoritesChange);
    super.dispose();
  }

  bool _matchesSearch(Restaurant r) {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return r.name.toLowerCase().contains(q) ||
        r.location.toLowerCase().contains(q);
  }

  bool _matchesFilters(Restaurant r) {
    // 1. Category Filter
    if (_activeCategory != "Tous") {
      if (r.category != _activeCategory) return false;
    }
    // 2. Meal Type Filter
    if (_activeMealType != null) {
       if (!r.mealTypes.contains(_activeMealType)) return false;
    }
    return true;
  }

  void _openDetails(Restaurant r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [const Color(0xFF2ABF9E), const Color(0xFF1E8F75)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2ABF9E).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user?.firstName.isNotEmpty == true ? user!.firstName[0].toUpperCase() : "G",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user != null ? "Salut, ${user.firstName} 👋" : "Découvrir",
                              style: const TextStyle(
                                fontSize: 13,
                                color: textMuted,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const Text(
                              "Restaurants",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                                fontFamily: "Poppins",
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.tune_rounded, color: textDark, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    "Trouvez les meilleurs\nrestaurants près de vous...",
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Rechercher",
                      prefixIcon: const Icon(Icons.search, color: textMuted),
                      filled: true,
                      fillColor: bg,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: brand),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filters
                  SizedBox(
                    height: 56,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      clipBehavior: Clip.none,
                      children: [
                        // Category Filters
                        ...["Tous", "Restaurant", "Café", "Pâtisserie"].map((f) {
                          final selected = _activeCategory == f && !_showOnlyFavorites;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: selected ? Colors.white : textMuted,
                                ),
                              ),
                              selected: selected,
                              onSelected: (_) => setState(() {
                                _activeCategory = f;
                                _showOnlyFavorites = false;
                              }),
                              selectedColor: brand,
                              backgroundColor: Colors.white,
                              side: selected
                                  ? BorderSide.none
                                  : const BorderSide(color: border),
                              shape: const StadiumBorder(),
                            ),
                          );
                        }).toList(),

                        // Favorites Filter
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              "❤ Favoris",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _showOnlyFavorites ? Colors.white : Colors.pink[400],
                              ),
                            ),
                            selected: _showOnlyFavorites,
                            onSelected: (val) => setState(() => _showOnlyFavorites = val),
                            selectedColor: Colors.pink[400],
                            backgroundColor: Colors.white,
                            side: _showOnlyFavorites ? BorderSide.none : BorderSide(color: Colors.pink[100]!),
                            shape: const StadiumBorder(),
                          ),
                        ),
  
                        // Divider
                        Container(
                          height: 20, 
                          width: 1, 
                          color: Colors.grey[300], 
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                        ),
  
                        // Meal Type Filters
                        ...["Petit-déjeuner", "Déjeuner", "Dîner", "Dessert"].map((m) {
                           final selected = _activeMealType == m;
                           return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                m,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: selected ? Colors.white : Colors.indigo[400],
                                ),
                              ),
                              selected: selected,
                              onSelected: (val) => setState(() => _activeMealType = selected ? null : m), // Toggle
                              selectedColor: Colors.indigo,
                              backgroundColor: Colors.indigo[50],
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _load(force: true),
                      color: brand,
                      child: _filteredRestaurants.isEmpty 
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _showOnlyFavorites ? Icons.favorite_border : Icons.search_off, 
                                        size: 64, 
                                        color: Colors.grey[300]
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _showOnlyFavorites ? "Aucun favoris pour le moment" : "Aucun restaurant trouvé",
                                        style: TextStyle(color: textMuted, fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _showOnlyFavorites ? "Cliquez sur le cœur pour en ajouter un !" : "Tirez pour actualiser la zone", 
                                        style: TextStyle(color: Colors.grey, fontSize: 12)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                              itemCount: _filteredRestaurants.length,
                              itemBuilder: (context, index) {
                                final restaurant = _filteredRestaurants[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _RestaurantCard(
                                    restaurant: restaurant,
                                    onTap: () => _openDetails(restaurant),
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  const _RestaurantCard({required this.restaurant, required this.onTap});

  static const textDark = Color(0xFF1E1E1E);
  static const textMuted = Color(0xFF6E6E6E);
  static const brand = Color(0xFF2ABF9E);

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService();
    final isFav = favorites.isFavorite(restaurant.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Placeholder based on Type (No Photos)
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: _getCategoryGradient(restaurant.category), 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Container(
                             padding: const EdgeInsets.all(12),
                             decoration: BoxDecoration(
                               color: Colors.white.withOpacity(0.2),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(
                                _getCategoryIcon(restaurant.category),
                                size: 36,
                                color: Colors.white,
                              ),
                          ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        if (restaurant.category.isNotEmpty)
                          Row(
                            children: [
                              if (isFav)
                                const Icon(Icons.favorite, color: Colors.pink, size: 16),
                              if (isFav) const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: brand.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text(
                                  restaurant.category,
                                  style: const TextStyle(color: brand, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: textMuted, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${restaurant.location} • ${restaurant.distance}",
                            style: const TextStyle(color: textMuted, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Specialties tags
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: restaurant.specialties.take(3).map((s) => 
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              s.name, 
                              style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  IconData _getCategoryIcon(String category) {
    if (category.contains("Pizza")) return Icons.local_pizza_outlined;
    if (category.contains("Burger")) return Icons.lunch_dining_outlined;
    if (category.contains("Café")) return Icons.local_cafe_outlined;
     if (category.contains("Sushi") || category.contains("Japonais")) return Icons.set_meal_outlined;
    if (category.contains("Pâtisserie")) return Icons.cake_outlined;
    return Icons.restaurant_menu_outlined;
  }

  List<Color> _getCategoryGradient(String category) {
      if (category.contains("Pizza")) return [const Color(0xFFFF9966), const Color(0xFFFF5E62)]; // Orange/Red
      if (category.contains("Burger")) return [const Color(0xFFF2994A), const Color(0xFFF2C94C)]; // Orange/Yellow
      if (category.contains("Café") || category.contains("Pâtisserie")) return [const Color(0xFFD4A76A), const Color(0xFF8B5E3C)]; // Coffee Brown
      if (category.contains("Japonais")) return [const Color(0xFFFF512F), const Color(0xFFDD2476)]; // Pink/Red
      if (category.contains("Mexicain")) return [const Color(0xFF56AB2F), const Color(0xFFA8E063)]; // Green
      // Default Teal
      return [const Color(0xFF2ABF9E), const Color(0xFF1E8F75)];
  }
}
