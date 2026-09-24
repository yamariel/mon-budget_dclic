import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/buget_colors.dart';
import '../controllers/transaction_controller.dart';
import '../core/views/bottom_nav_bar.dart';
import '../data/category.dart';
import 'stats_screen.dart';
import 'transaction_form_screen.dart';
import 'transcation_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BottomNavBar(),
      child: const _HomeScaffold(),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<BottomNavBar>();

    final pages = [
      const _HomeContent(),
      const TranscationListScreen(),
      const StatsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Budgeto')),
      drawer: Drawer(),
      body: pages[nav.currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final transactionController = context.read<TransactionController>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: transactionController,
                child: const TransactionFormScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.currentIndex,
        onDestinationSelected: nav.setIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Liste'),
          NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Stats'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();
    final currency = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F',
      decimalDigits: 0,
    );
    final recent = controller.transactions.take(5).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: BudgetColors.balance,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Solde courant',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                currency.format(controller.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Transactions récentes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (recent.isEmpty) const Text('Aucune transaction pour le moment.'),
        for (final t in recent)
          ListTile(
            title: Text(categoryById(t.categoryId).name),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(t.date)),
            trailing: Text(
              currency.format(t.signedAmount),
              style: TextStyle(
                color: t.signedAmount >= 0
                    ? BudgetColors.income
                    : BudgetColors.expense,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
