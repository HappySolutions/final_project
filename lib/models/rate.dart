class Rate {
  int? id;
  double? usd;
  double? egp;

  Rate({required double usd, required double egp});

  Rate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usd = json['usd'];
    egp = json['egp'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': usd, 'description': usd};
  }
}
