import 'package:flutter_application_1/models/category_classifier.dart';

import '../models/raw_sms.dart';
import '../models/category.dart';
import '../models/transaction_type.dart';

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
}

class SmsParser {
  static ParsedTransaction? parseFromRawSms(RawSms sms) {
    final body = sms.body.toLowerCase();

    // 🔴 SAFETY: skip very long SMS (promos, statements, junk)
    if (body.length > 500) return null;

    // 🔴 SAFE amount regex (NO unicode, NO greedy backtracking)
    final amountMatch = RegExp(
      r'(rs|inr)\s*:?(\d{1,6}(\.\d{1,2})?)',
    ).firstMatch(body);

    if (amountMatch == null) return null;

    final amount = double.tryParse(amountMatch.group(2)!);
    if (amount == null || amount <= 0) return null;

    // 🔴 Type detection
    final TransactionType type =
        body.contains('credit') || body.contains('credited')
        ? TransactionType.credit
        : TransactionType.debit;

    // 🔴 Merchant extraction (VERY SIMPLE + SAFE)
    final merchant = _extractMerchant(body);

    final category = CategoryClassifier.classify(merchant);

    return ParsedTransaction(
      amount: amount,
      type: type,
      merchant: merchant,
      category: category,
      date: sms.date,
    );
  }

  static String _extractMerchant(String body) {
    if (body.contains('swiggy')) return 'Swiggy';
    if (body.contains('zomato')) return 'Zomato';
    if (body.contains('amazon')) return 'Amazon';
    if (body.contains('flipkart')) return 'Flipkart';
    if (body.contains('uber')) return 'Uber';
    if (body.contains('ola')) return 'Ola';
    if (body.contains('atm')) return 'ATM';

    return 'UNKNOWN';
  }
}
