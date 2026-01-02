import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../services/restaurant_service.dart';
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
  final _searchCtrl = TextEditingController();

  String _activeFilter = "Restaurants";
  bool _loading = true;

  List<Restaurant> _favorites = [];
  List<Restaurant> _recommended = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final fav = await _service.getFavorites();
    final rec = await _service.getRecommended();
    setState(() {
      _favorites = fav;
      _recommended = rec;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matchesSearch(Restaurant r) {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return r.name.toLowerCase().contains(q) ||
        r.location.toLowerCase().contains(q);
  }

  bool _matchesFilter(Restaurant r) {
    if (_activeFilter == "Restaurants") {
      return r.category == "Restaurant" || r.category == "Pâtisserie";
    }
    return r.category == _activeFilter;
  }

  void _openDetails(Restaurant r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favShown =
        _favorites.where((r) => _matchesSearch(r) && _matchesFilter(r)).toList();
    final recShown = _recommended
        .where((r) => _matchesSearch(r) && _matchesFilter(r))
        .toList();

    final w = MediaQuery.of(context).size.width;

    final favCardWidth = (w < 360) ? 132.0 : 140.0;
    final favImageSize = (w < 360) ? 126.0 : 136.0;
    final favListHeight = favImageSize + 78; // image + texts

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
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFA4E6D1),
                        ),
                        clipBehavior: Clip.antiAlias,
                        
                      ),
                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "Restaurants",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, color: textDark),
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
                  Wrap(
                    spacing: 10,
                    children: ["Restaurants", "Café", "Gastronomie"].map((f) {
                      final selected = _activeFilter == f;
                      return ChoiceChip(
                        label: Text(
                          f,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : textMuted,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() => _activeFilter = f),
                        selectedColor: brand,
                        backgroundColor: Colors.white,
                        side: selected
                            ? BorderSide.none
                            : const BorderSide(color: border),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                      children: [
                        const Text(
                          "Favoris",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          height: favListHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: favShown.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 14),
                            itemBuilder: (_, i) => _FavoriteTile(
                              restaurant: favShown[i],
                              onTap: () => _openDetails(favShown[i]),
                              cardWidth: favCardWidth,
                              imageSize: favImageSize,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),
                        const Text(
                          "Recommandés",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textDark,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const SizedBox(height: 14),

                        ...recShown.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _RecommendedCard(
                              restaurant: r,
                              onTap: () => _openDetails(r),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  final double cardWidth;
  final double imageSize;

  const _FavoriteTile({
    required this.restaurant,
    required this.onTap,
    required this.cardWidth,
    required this.imageSize,
  });

  static const textDark = Color(0xFF1E1E1E);
  static const textMuted = Color(0xFF6E6E6E);
  static const brand = Color(0xFF2ABF9E);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                restaurant.image,
                width: cardWidth,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: brand),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    restaurant.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: textMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    restaurant.distance,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  const _RecommendedCard({required this.restaurant, required this.onTap});

  static const textDark = Color(0xFF1E1E1E);
  static const textMuted = Color(0xFF6E6E6E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  restaurant.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 6),
                    RatingStars(rating: restaurant.rating),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.location,
                      style: const TextStyle(fontSize: 12, color: textMuted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      restaurant.distance,
                      style: const TextStyle(fontSize: 12, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
