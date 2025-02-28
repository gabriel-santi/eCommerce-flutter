import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

class ProductsFakeRepository {
  ProductsFakeRepository._();

  static ProductsFakeRepository instance = ProductsFakeRepository._();

  final List<Product> _products = kTestProducts;

  List<Product> getProducts() {
    return _products;
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }
}
