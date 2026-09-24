import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/transaction_controller.dart';
import '../data/category.dart';
import '../enums/transactions_type.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  Map<Category, double> _breakdown(List<Transaction> transactions) {
    final result = <Category, double>{};
    for (final t in transactions) {
      if (t.type == TransactionType.depense) {
        final category = categoryById(t.categoryId);
        result[category] = (result[category] ?? 0) + t.amount;
      }
    }
    return result;
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final transactions = controller.allTransactions;
    final breakdown = _breakdown(transactions);

    if (breakdown.isEmpty) {
      return const Center(
        child: Text('Aucune dépense enregistrée pour le moment.'),
      );
    }

    final totalExpense = breakdown.values.fold(0.0, (sum, val) => sum + val);

    final currency = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F',
      decimalDigits: 0,
    );

    final sections = breakdown.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final percentage = totalExpense > 0 ? (amount / totalExpense * 100) : 0.0;
      final color = _hexToColor(category.colorHex);

      return PieChartSectionData(
        color: color,
        value: amount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Répartition des dépenses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: breakdown.entries.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                final color = _hexToColor(category.colorHex);

                return ListTile(
                  leading: CircleAvatar(radius: 12, backgroundColor: color),
                  title: Text(category.name),
                  trailing: Text(
                    currency.format(amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
