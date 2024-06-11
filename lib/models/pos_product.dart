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
    isAvailable = json['isAvaliable'] == 1 ? true : false;
    image = json['image'];
    categoryId = json['categoryId'];
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
      'isAvaliable': isAvailable,
      'image': image,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
    };
  }
}
