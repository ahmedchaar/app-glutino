import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';

class ProductDetailSheet extends StatelessWidget {
  final Product? product;
  final String scannedCode;

  final VoidCallback? onSave;
  final VoidCallback? onAddToShoppingList; // New callback

  const ProductDetailSheet({
    super.key, 
    this.product, 
    required this.scannedCode, 
    this.onSave,
    this.onAddToShoppingList,
  });

  Color get _statusColor {
    if (product == null) return Colors.grey;
    switch (product!.status) {
      case GlutenStatus.safe:
        return const Color(0xFF4CAF50);
      case GlutenStatus.mayContain:
        return const Color(0xFFFFC107);
      case GlutenStatus.contains:
        return const Color(0xFFE53935);
      case GlutenStatus.unknown:
        return Colors.grey;
    }
  }

  String get _statusText {
    if (product == null) return "Produit inconnu";
    switch (product!.status) {
      case GlutenStatus.safe:
        return "Sans gluten détecté";
      case GlutenStatus.mayContain:
        return "Peut contenir du gluten";
      case GlutenStatus.contains:
        return "Contient du gluten";
      case GlutenStatus.unknown:
        return "Statut inconnu";
    }
  }

  IconData get _statusIcon {
    if (product == null) return Icons.help_outline;
    switch (product!.status) {
      case GlutenStatus.safe:
        return Icons.check_circle_outline;
      case GlutenStatus.mayContain:
        return Icons.warning_amber_rounded;
      case GlutenStatus.contains:
        return Icons.cancel_outlined;
      case GlutenStatus.unknown:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          
          if (product != null) ...[
            if (product!.imageUrl.isNotEmpty)
              Image.network(product!.imageUrl, height: 100)
            else
               const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              product!.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3E50),
              ),
            ),
            Text(
              product!.brands,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ] else ...[
             const Icon(Icons.error_outline, size: 60, color: Colors.grey),
             const SizedBox(height: 16),
             Text(
              'Code: $scannedCode',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
             Text(
              'Produit non trouvé',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3E50),
              ),
            ),
          ],
          
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _statusColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_statusIcon, color: _statusColor, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _statusText,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
           
           if (product != null && product!.ingredientsText.isNotEmpty) ...[
             const SizedBox(height: 20),
             Align(
               alignment: Alignment.centerLeft,
               child: Text("Ingrédients:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
             ),
             const SizedBox(height: 8),
             Text(
               product!.ingredientsText,
               maxLines: 4,
               overflow: TextOverflow.ellipsis,
               style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
             ),
           ],

          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onAddToShoppingList,
                  icon: const Icon(Icons.playlist_add, color: Color(0xFF2ECC71)),
                  label: Text("Ajouter liste", style: GoogleFonts.poppins(color: const Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
                ),
              ),
              if (product != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2ECC71),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Enregistrer", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }
}
