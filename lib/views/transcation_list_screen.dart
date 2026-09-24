import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/transaction_controller.dart';
import '../core/buget_colors.dart';
import '../data/category.dart';

class TranscationListScreen extends StatelessWidget {
  const TranscationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final currency = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F',
      decimalDigits: 0,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String?>(
            initialValue: controller.selectedCategoryId,
            onChanged: (value) {
              controller.filterByCategory(value);
            },
            items: [
              const DropdownMenuItem(value: null, child: Text('Toutes')),
              ...categories.map(
                (category) => DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              final transaction = controller.transactions[index];
              return Dismissible(
                key: Key(transaction.id),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) {
                  controller.deleteTransaction(transaction.id);
                },
                background: Container(
                  color: BudgetColors.expense,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(categoryById(transaction.categoryId).name),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(transaction.date),
                  ),
                  trailing: Text(
                    currency.format(transaction.signedAmount),
                    style: TextStyle(
                      color: transaction.signedAmount >= 0
                          ? BudgetColors.income
                          : BudgetColors.expense,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
