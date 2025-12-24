import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  Future<Product?> fetchProduct(String barcode) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$barcode.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['status'] == 1) { // 1 means product found
          return Product.fromJson(data);
        }
      }
    } catch (e) {
      // Handle network error
    }
    return null;
  }
}
