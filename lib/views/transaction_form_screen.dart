import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/transaction_controller.dart';
import '../core/buget_colors.dart';
import '../core/theme.dart';
import '../data/category.dart';
import '../enums/transactions_type.dart';
import '../models/transaction.dart' as model;
import '../widgets/my_button.dart';
import '../widgets/my_text_field.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TransactionType _type = TransactionType.depense;
  String? _categoryId;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un montant valide'),
          backgroundColor: BudgetColors.expense,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate() || _categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une catégorie'),
          backgroundColor: BudgetColors.expense,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await context.read<TransactionController>().addTransaction(
        model.Transaction(
          id: '',
          amount: amount,
          date: _date,
          note: _noteController.text.trim(),
          type: _type,
          categoryId: _categoryId!,
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: BudgetColors.expense,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle Transaction')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              MyTextField(
                controller: _amountController,
                hintText: "Montant",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.depense,
                        label: Text('Dépense'),
                      ),
                      ButtonSegment(
                        value: TransactionType.revenu,
                        label: Text('Revenu'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (s) => setState(() => _type = s.first),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(
                    labelText: "Catégories",
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _categoryId = v),
                  validator: (v) =>
                      v == null ? "Veuillez sélectionner une catégorie" : null,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    onTap: _selectDate,
                    leading: const Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                    ),
                    title: Text(DateFormat('dd/MM/yyyy').format(_date)),
                    trailing: const Icon(Icons.edit, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _noteController,
                hintText: "Note (optionnel)",
                obscureText: false,
              ),
              const SizedBox(height: 40),
              _saving
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : MyButton(
                      color: AppColors.primary,
                      onTap: _saveTransaction,
                      text: "Enregistrer",
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
