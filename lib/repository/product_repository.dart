
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  static const String _baseUrl = 'https://dummyjson.com';
  static const int _pageSize = 10;

  Future<ProductsResponse> fetchProducts({int skip = 0}) async {
    final uri = Uri.parse(
      '$_baseUrl/products?limit=$_pageSize&skip=$skip',
    );

    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 55),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductsResponse.fromJson(json);
      } else {
        throw HttpException(
          'Server error: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Something went wrong. Please try again.');
    }
  }
}
