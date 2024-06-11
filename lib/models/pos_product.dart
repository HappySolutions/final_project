class PosProduct {
  int? id;
  String? name;
  String? description;
  double? price;
  int? stock;
  bool? isAvailable;
  String? image;
  int? categoryId;
  String? categoryName;
  String? categoryDescription;

  PosProduct();

  PosProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    isAvailable = json['isAvailable'];
    image = json['image'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'isAvailable': isAvailable,
      'image': image,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
    };
  }
}
