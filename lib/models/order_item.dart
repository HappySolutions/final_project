import 'package:final_project/models/pos_product.dart';

class OrderItem {
  int? orderId;
  int? productCount;
  int? productId;
  PosProduct? product;

  OrderItem();

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productCount = json['productCount'] ?? 0;
    productId = json['productId'];
    product = PosProduct.fromJson(json);
  }
}

class OrderProducts {
  int? orderId;
  int? productCount;
  int? productId;
  String? productName;
  String? productImage;
  double? productPrice;

  OrderProducts();

  OrderProducts.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productCount = json['productCount'] ?? 0;
    productId = json['productId'];
    productName = json['productName'];
    productImage = json['productImage'];
    productPrice = json['productPrice'];
  }
}
