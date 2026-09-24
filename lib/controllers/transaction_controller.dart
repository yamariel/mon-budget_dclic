import 'package:flutter/foundation.dart';

import '../models/transaction.dart' as model;
import '../services/firebase_service.dart';

class TransactionController extends ChangeNotifier {
  final String uid;
  final FirestoreService _firestoreService = FirestoreService();

  List<model.Transaction> _allTransactions = [];
  DateTime? selectedMonth;
  String? selectedCategoryId;

  TransactionController(this.uid) {
    _firestoreService
        .watchTransactions(uid)
        .listen(
          (data) {
            _allTransactions = data;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Erreur lors de l\'écoute des transactions : $error');
          },
        );
  }

  List<model.Transaction> get allTransactions => _allTransactions;

  List<model.Transaction> get transactions {
    return _allTransactions.where((t) {
      final matchMonth =
          selectedMonth == null ||
          (t.date.year == selectedMonth!.year &&
              t.date.month == selectedMonth!.month);
      final matchCategory =
          selectedCategoryId == null || t.categoryId == selectedCategoryId;
      return matchMonth && matchCategory;
    }).toList();
  }

  double get balance =>
      _allTransactions.fold(0.0, (sum, t) => sum + t.signedAmount);

  void filterByMonth(DateTime? month) {
    selectedMonth = month;
    notifyListeners();
  }

  void filterByCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    notifyListeners();
  }

  Future<void> addTransaction(model.Transaction transaction) {
    return _firestoreService.addTransaction(uid, transaction);
  }

  Future<void> deleteTransaction(String transactionId) {
    return _firestoreService.deleteTransaction(uid, transactionId);
  }
}
