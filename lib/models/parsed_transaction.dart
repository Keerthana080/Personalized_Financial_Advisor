import 'category.dart';
import 'transaction_type.dart';

class ParsedTransaction {
  final double amount;
  final TransactionType type;
  final String merchant;
  final Category category;
  final DateTime date;

  ParsedTransaction({
    required this.amount,
    required this.type,
    required this.merchant,
    required this.category,
    required this.date,
  });

  @override
  String toString() {
    return '🧾 ${type.name.toUpperCase()} | ₹$amount | $merchant | ${category.name} | $date';
  }
}
