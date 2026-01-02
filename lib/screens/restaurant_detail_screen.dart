import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../widgets/rating_stars.dart';
import 'restaurant_map_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/favorites_service.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  static const bg = Color(0xFFF8F9FA);
  static const brand = Color(0xFF2ABF9E);
  final _favorites = FavoritesService();

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

  // No fake images anymore
  // final menuImages = ... removed

  @override
  void initState() {
    super.initState();
    _favorites.addListener(_onFavChange);
  }

  void _onFavChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _favorites.removeListener(_onFavChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          children: [
            // Title section (like Figma)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Exploration",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6E6E6E),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Text(
                          "Détails du lieu",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main image with overlay actions + bottom info
            // Main generic header with Category Color
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    colors: _getCategoryGradient(r.category), 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getCategoryGradient(r.category).first.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                             padding: const EdgeInsets.all(20),
                             decoration: BoxDecoration(
                               color: Colors.white.withOpacity(0.2),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(
                                _getCategoryIcon(r.category),
                                size: 64,
                                color: Colors.white,
                              ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            r.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Poppins",
                              letterSpacing: 2,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Row(
                        children: [
                          _CircleIconButton(
                            icon: _favorites.isFavorite(r.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor:
                                _favorites.isFavorite(r.id) ? Colors.pink : const Color(0xFF6E6E6E),
                            onTap: () => _favorites.toggleFavorite(r.id),
                          ),
                          const SizedBox(width: 10),
                          _CircleIconButton(
                            icon: Icons.share_outlined,
                            iconColor: const Color(0xFF6E6E6E),
                            onTap: () async {
                              await Share.share(
                                  "Découvre ${r.name} sur Glutino");
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                RatingStars(rating: r.rating),
                                const SizedBox(width: 8),
                                Text(
                                  r.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(r.location,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Direction button → Map page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brand,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () async {
                   final lat = r.latitude;
                   final lng = r.longitude;
                   final name = Uri.encodeComponent(r.name);
                   
                   // 1. Try Native Maps App (geo scheme)
                   final Uri geoUrl = Uri.parse("geo:$lat,$lng?q=$lat,$lng($name)");
                   
                   // 2. Fallback to Web Google Maps
                   final Uri webUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

                   try {
                     if (await canLaunchUrl(geoUrl)) {
                       await launchUrl(geoUrl);
                     } else if (await canLaunchUrl(webUrl)) {
                       await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                     } else {
                       throw 'Could not launch maps';
                     }
                   } catch (e) {
                     if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text("Impossible d'ouvrir la carte")),
                       );
                     }
                   }
                },
                icon: const Icon(Icons.map_outlined),
                label: const Text(
                  "Ouvrir dans Maps",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins"),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Community Reviews Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Avis de la communauté",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins"),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                           children: [
                             const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
                             const SizedBox(width: 4),
                             Text("Gluten Safe", style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold)),
                           ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (r.reviews.isEmpty)
                     const Text("Pas encore d'avis.", style: TextStyle(color: Colors.grey)),

                  ...List.generate(r.reviews.length, (index) {
                    final review = r.reviews[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                             BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: brand.withOpacity(0.2),
                                  child: Text(review.userName[0], style: const TextStyle(color: brand, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(review.userName,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins")),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(review.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(review.comment,
                                style: const TextStyle(
                                    color: Color(0xFF424242),
                                    fontSize: 14,
                                    height: 1.4)),
                             const SizedBox(height: 8),
                             Text(review.date, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
