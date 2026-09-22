import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mon_budget/models/transaction.dart' as model;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _transactionsRef(String uid) =>
      _db.collection('users').doc(uid).collection('transactions');

  Stream<List<model.Transaction>> watchTransactions(String uid) {
    return _transactionsRef(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => model.Transaction.fromJson(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Future<void> addTransaction(String uid, model.Transaction transaction) {
    return _transactionsRef(uid).add(transaction.toJson());
  }

  Future<void> deleteTransaction(String uid, String transactionId) {
    return _transactionsRef(uid).doc(transactionId).delete();
  }
}
