import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/transactions_type.dart';

class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String note;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note = '',
  });

  factory Transaction.fromJson(String id, Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['date'] is String) {
      parsedDate = DateTime.tryParse(json['date']) ?? DateTime.now();
    } else if (json['date'] is Timestamp) {
      parsedDate = (json['date'] as Timestamp).toDate();
    } else {
      parsedDate = DateTime.now();
    }

    return Transaction(
      id: id,
      amount: (json['amount'] ?? 0).toDouble(),
      type: json['type'] == 'revenu'
          ? TransactionType.revenu
          : TransactionType.depense,
      categoryId: json['categoryId'] ?? '',
      date: parsedDate,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'type': type == TransactionType.revenu ? 'revenu' : 'depense',
    'categoryId': categoryId,
    'date': date.toIso8601String(),
    'note': note,
  };

  double get signedAmount => type == TransactionType.revenu ? amount : -amount;
}
