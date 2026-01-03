import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../scanner_screen.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/saved_products_service.dart';
import '../../providers/shopping_provider.dart';

class ProductsTab extends StatefulWidget {
  final bool showSavedOnInit;
  
  const ProductsTab({super.key, this.showSavedOnInit = false});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  // 0 = Scanner, 1 = Enregistrés
  int _selectedSegment = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.showSavedOnInit) {
      _selectedSegment = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_initialized) {
      final user = context.read<AuthService>().currentUser;
      if (user != null) {
        context.read<SavedProductsService>().init(user.email);
      }
      _initialized = true;
    }
  }

  void _openScanner() async {
     final result = await Navigator.of(context).push(
       MaterialPageRoute(builder: (context) => const ScannerScreen())
     );

     if (result != null && result is Product) {
       await context.read<SavedProductsService>().addProduct(result);
       setState(() {
         _selectedSegment = 1; 
       });
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text("Produit enregistré : ${result.name}"),
             backgroundColor: const Color(0xFF2ECC71),
           )
         );
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Title
          Text(
            'Produits',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Scanner et gérer vos produits',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 24),

          // Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SegmentButton(
                    title: 'Scanner',
                    icon: Icons.qr_code_scanner,
                    isSelected: _selectedSegment == 0,
                    onTap: () => setState(() => _selectedSegment = 0),
                  ),
                ),
                Expanded(
                  child: Consumer<SavedProductsService>(
                    builder: (context, service, _) => _SegmentButton(
                      title: 'Enregistrés',
                      badgeCount: service.products.isNotEmpty ? service.products.length : null,
                      isSelected: _selectedSegment == 1,
                      onTap: () => setState(() => _selectedSegment = 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Main Scanner Area (Mockup visual)
          if (_selectedSegment == 0) ...[
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ]
              ),
              child: CustomPaint(
                painter: _DashedBorderPainter(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F8F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF2ECC71),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Prêt à scanner',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Positionnez le code-barre du produit\ndans le cadre',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48), // Increased spacing

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _openScanner,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ouvrir la caméra'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            
          ] else ...[
             Consumer<SavedProductsService>(
               builder: (context, service, _) {
                 if (service.products.isEmpty) {
                   return Center(child: Padding(
                     padding: const EdgeInsets.only(top: 50),
                     child: Text("Aucun produit enregistré", style: GoogleFonts.poppins(color: Colors.grey)),
                   ));
                 }
                 
                 return ListView.builder(
                   physics: const NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   itemCount: service.products.length,
                   itemBuilder: (context, index) {
                     final product = service.products[index];
                     return _ProductCard(
                       product: product,
                       onDelete: () async {
                         await service.removeProduct(product.barcode);
                       },
                       onAdd: () {
                         Provider.of<ShoppingProvider>(context, listen: false)
                             .addProduct(product.name);
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text("${product.name} ajouté à la liste"),
                             backgroundColor: const Color(0xFF2ECC71),
                             duration: const Duration(seconds: 2),
                           )
                         );
                       },
                     );
                   },
                 );
               }
             )
          ]
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.product, 
    required this.onDelete,
    required this.onAdd,
  });

  Color get _statusColor {
    switch (product.status) {
      case GlutenStatus.safe: return const Color(0xFF4CAF50);
      case GlutenStatus.mayContain: return const Color(0xFFFFC107);
      case GlutenStatus.contains: return const Color(0xFFE53935);
      case GlutenStatus.unknown: return Colors.grey;
    }
  }

  String get _statusText {
    switch (product.status) {
      case GlutenStatus.safe: return "Sans gluten";
      case GlutenStatus.mayContain: return "Peut contenir";
      case GlutenStatus.contains: return "Contient";
      case GlutenStatus.unknown: return "Inconnu";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ]
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.imageUrl.isNotEmpty
                ? Image.network(product.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                : Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: const Color(0xFF2C3E50)),
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.brands,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusText,
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: _statusColor),
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.playlist_add, color: Color(0xFF2ECC71)),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          )
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final int? badgeCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.title,
    this.icon,
    this.badgeCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: isSelected ? Colors.white : const Color(0xFF2C3E50), size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            if (badgeCount != null && badgeCount! > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFF2ECC71),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;
    final Path path = Path();
    
    // Simple rounded rect path
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), 
      const Radius.circular(20)
    );
    
    path.addRRect(rrect);
    
    // Making it truly dashed
    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
