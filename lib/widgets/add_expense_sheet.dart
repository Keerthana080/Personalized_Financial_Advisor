import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';
import '../models/category.dart';
import '../models/transaction_type.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.other;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Expense',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Amount
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Category
          DropdownButtonFormField<Category>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: Category.values.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCategory = value!);
            },
          ),
          const SizedBox(height: 16),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveExpense,
              child: const Text('Save Expense'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveExpense() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final box = Hive.box<TransactionModel>('transactions');

    box.add(
      TransactionModel(
        amount: amount,
        type: TransactionType.debit,
        merchant: 'Manual Entry',
        category: _selectedCategory,
        date: DateTime.now(),
      ),
    );

    Navigator.pop(context);
  }
}
