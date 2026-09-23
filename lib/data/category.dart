import '../models/category.dart';

final categories = [
  Category(id: 'alimentation', name: 'Alimentation', colorHex: '#E06666'),
  Category(id: 'transport', name: 'Transport', colorHex: '#2E75B6'),
  Category(id: 'logement', name: 'Logement', colorHex: '#3CB371'),
  Category(id: 'loisirs', name: 'Loisirs', colorHex: '#F6B93B'),
  Category(id: 'sante', name: 'Santé', colorHex: '#8E7CC3'),
  Category(id: 'autre', name: 'Autre', colorHex: '#9AA5B1'),
];
Category categoryById(String id) =>
    categories.firstWhere((c) => c.id == id, orElse: () => categories.last);