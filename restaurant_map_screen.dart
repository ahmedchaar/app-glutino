import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/restaurant_model.dart';
import 'restaurant_detail_screen.dart';

enum TransportMode { car, walk, bike }

class RestaurantMapScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantMapScreen({super.key, required this.restaurant});

  @override
  State<RestaurantMapScreen> createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  static const bg = Color(0xFFF8F9FA);
  static const brand = Color(0xFF2ABF9E);
  static const textDark = Color(0xFF1E1E1E);
  static const textMuted = Color(0xFF6E6E6E);
  static const border = Color(0xFFEDEDED);

  final _searchCtrl = TextEditingController();
  TransportMode _mode = TransportMode.car;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _travelTime() {
    // restaurant.distance is like "5 min en voiture"
    final raw = widget.restaurant.distance.replaceAll(RegExp(r'[^0-9.]'), '');
    final base = double.tryParse(raw) ?? 8.0;

    switch (_mode) {
      case TransportMode.walk:
        return "${(base * 2.5).round()} min à pied";
      case TransportMode.bike:
        return "${(base * 1.5).round()} min à vélo";
      case TransportMode.car:
        return widget.restaurant.distance;
    }
  }

  Future<void> _callRestaurant() async {
    final phone = widget.restaurant.phone.replaceAll(' ', '');
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  Future<void> _shareLocation() async {
    await Share.share("Découvre ${widget.restaurant.name} sur Glutino");
  }

  void _openInMaps() {
    // using restaurant name/location as query
    MapsLauncher.launchQuery(
        "${widget.restaurant.name} ${widget.restaurant.location}");
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Header (back + search)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: bg, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back,
                            size: 20, color: textDark),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: "Rechercher une adresse...",
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
                  ],
                ),
              ),
            ),

            // Map area (mock)
            Positioned.fill(
              top: 140,
              child: Container(
                color: const Color(0xFFE8E8E8),
                child: Stack(
                  children: [
                    // Route path (dashed)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RoutePainter(),
                      ),
                    ),

                    // Transport mode
                    Positioned(
                      top: 16,
                      left: 24,
                      child: Row(
                        children: [
                          _ModeBtn(
                            selected: _mode == TransportMode.car,
                            icon: Icons.directions_car,
                            onTap: () =>
                                setState(() => _mode = TransportMode.car),
                          ),
                          const SizedBox(width: 8),
                          _ModeBtn(
                            selected: _mode == TransportMode.walk,
                            icon: Icons.directions_walk,
                            onTap: () =>
                                setState(() => _mode = TransportMode.walk),
                          ),
                          const SizedBox(width: 8),
                          _ModeBtn(
                            selected: _mode == TransportMode.bike,
                            icon: Icons.directions_bike,
                            onTap: () =>
                                setState(() => _mode = TransportMode.bike),
                          ),
                        ],
                      ),
                    ),

                    // Map controls
                    Positioned(
                      top: 16,
                      right: 24,
                      child: Column(
                        children: [
                          _SquareBtn(
                              icon: Icons.open_in_new, onTap: _openInMaps),
                          const SizedBox(height: 10),
                          _SquareBtn(
                              icon: Icons.share_outlined,
                              onTap: _shareLocation),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom restaurant card
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -4))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(r.image,
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textDark,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text("Ouvert • Ferme à 21h00",
                                    style: TextStyle(color: textMuted)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.navigation_outlined,
                                        size: 14, color: textMuted),
                                    const SizedBox(width: 6),
                                    Text(_travelTime(),
                                        style:
                                            const TextStyle(color: textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: bg,
                                side: BorderSide.none,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _openInMaps,
                              icon: const Icon(Icons.navigation_outlined,
                                  color: brand, size: 18),
                              label: const Text("Itinéraire",
                                  style: TextStyle(
                                      color: brand,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: bg,
                                side: BorderSide.none,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _callRestaurant,
                              icon: const Icon(Icons.phone_outlined,
                                  color: brand, size: 18),
                              label: const Text("Appeler",
                                  style: TextStyle(
                                      color: brand,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brand,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      RestaurantDetailScreen(restaurant: r)),
                            );
                          },
                          child: const Text(
                            "Voir les détails",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeBtn extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _ModeBtn(
      {required this.selected, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2ABF9E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))
          ],
        ),
        child: Icon(icon,
            size: 18, color: selected ? Colors.white : const Color(0xFF6E6E6E)),
      ),
    );
  }
}

class _SquareBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SquareBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))
          ],
        ),
        child: Icon(icon, color: const Color(0xFF2ABF9E)),
      ),
    );
  }
}

// Draw a simple dashed route + markers (like your Figma mock)
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // grid-ish background lines (subtle)
    final gridPaint = Paint()
      ..color = const Color(0xFFB0B0B0).withOpacity(0.25)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // route path
    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.12)
      ..lineTo(size.width * 0.50, size.height * 0.22)
      ..lineTo(size.width * 0.62, size.height * 0.30)
      ..lineTo(size.width * 0.62, size.height * 0.42)
      ..lineTo(size.width * 0.46, size.height * 0.52)
      ..lineTo(size.width * 0.36, size.height * 0.60);

    final routePaint = Paint()
      ..color = const Color(0xFF2ABF9E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // dashed effect (simple)
    const dashWidth = 10.0;
    const dashSpace = 6.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = math.min(dashWidth, metric.length - distance);
        final extract = metric.extractPath(distance, distance + len);
        canvas.drawPath(extract, routePaint);
        distance += dashWidth + dashSpace;
      }
    }

    // markers
    final userPaint = Paint()..color = const Color(0xFF2ABF9E);
    final restPaint = Paint()..color = const Color(0xFFFF6B6B);

    canvas.drawCircle(
        Offset(size.width * 0.50, size.height * 0.12), 10, userPaint);
    canvas.drawCircle(
        Offset(size.width * 0.36, size.height * 0.60), 10, restPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
