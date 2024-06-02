class PosCategory {
  int? id;
  String? name;
  String? description;

  PosCategory(this.id, this.name, this.description);

  PosCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
