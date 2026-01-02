import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/shopping_provider.dart';

class ShoppingListTab extends StatefulWidget {
  const ShoppingListTab({super.key});

  @override
  State<ShoppingListTab> createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends State<ShoppingListTab> {
  final TextEditingController _controller = TextEditingController();

  void _handleAddItem() {
    if (_controller.text.isNotEmpty) {
      Provider.of<ShoppingProvider>(context, listen: false).addItem(_controller.text);
      _controller.clear();
    }
  }

  void _handleShare(BuildContext context) {
    final text = Provider.of<ShoppingProvider>(context, listen: false).getShareableText();
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Ma Liste de Courses', style: GoogleFonts.poppins(color: const Color(0xFF2C3E50), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF2ECC71)),
            onPressed: () => _handleShare(context),
            tooltip: "Partager la liste",
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
               Provider.of<ShoppingProvider>(context, listen: false).clearCompleted();
            },
            tooltip: "Supprimer les terminés",
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un produit (ex: Pâtes)',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF0F2F5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _handleAddItem(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  mini: true,
                  onPressed: _handleAddItem,
                  backgroundColor: const Color(0xFF2ECC71),
                  child: const Icon(Icons.add, color: Colors.white),
                  elevation: 0,
                ),
              ],
            ),
          ),
          
          // List Section
          Expanded(
            child: Consumer<ShoppingProvider>(
              builder: (context, provider, child) {
                if (provider.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Votre liste est vide',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.items.length,
                  itemBuilder: (context, index) {
                    final item = provider.items[index];
                    return Dismissible(
                      key: Key(item.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red[100],
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        provider.removeItem(item.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: item.isCompleted ? null : Border.all(color: Colors.transparent),
                          boxShadow: item.isCompleted ? [] : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Checkbox(
                                value: item.isCompleted,
                                activeColor: const Color(0xFF2ECC71),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                onChanged: (val) => provider.toggleStatus(item.id),
                              ),
                              title: Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                  color: item.isCompleted ? Colors.grey : const Color(0xFF2C3E50),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: item.type != 'Perso' ? Text(item.type, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)) : null,
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                onPressed: () => provider.removeItem(item.id),
                              ),
                            ),
                            if (item.alternative != null && !item.isCompleted)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F8F5),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFF2ECC71)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Alternative: ${item.alternative}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFF27AE60),
                                          fontStyle: FontStyle.italic,
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}