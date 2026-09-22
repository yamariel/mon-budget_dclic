class Category {
  final String id;
  final String name;
  final String colorHex;
  const Category({required this.id, required this.name, required this.colorHex});

  factory Category.fromJson(String id, Map<String, dynamic> json) {
    return Category(
      id: id, 
      name: json['name'], 
      colorHex: json['colorHex']
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'colorHex': colorHex
  };
}
