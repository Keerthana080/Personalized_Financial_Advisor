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

/// 🔴 MUST be top-level for compute()
List<ParsedTransaction> parseSmsBatch(List<RawSms> list) {
  final results = <ParsedTransaction>[];

  for (final sms in list) {
    final body = sms.body;
    if (body.isEmpty || body.length > 500) continue;

    final lower = body.toLowerCase();

    // SAFE amount extraction (NO regex backtracking)
    int idx = lower.indexOf('rs');
    if (idx == -1) idx = lower.indexOf('inr');
    if (idx == -1) continue;

    final amountStr = lower
        .substring(idx)
        .replaceAll(RegExp(r'[^0-9.]'), ' ')
        .trim()
        .split(' ')
        .first;

    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) continue;

    final type = lower.contains('credit')
        ? TransactionType.credit
        : TransactionType.debit;

    final merchant = _extractMerchant(lower);
    final category = CategoryClassifier.classify(merchant);

    results.add(
      ParsedTransaction(
        amount: amount,
        type: type,
        merchant: merchant,
        category: category,
        date: sms.date,
      ),
    );
  }

  return results;
}

String _extractMerchant(String body) {
  if (body.contains('swiggy')) return 'Swiggy';
  if (body.contains('zomato')) return 'Zomato';
  if (body.contains('amazon')) return 'Amazon';
  if (body.contains('flipkart')) return 'Flipkart';
  if (body.contains('uber')) return 'Uber';
  if (body.contains('ola')) return 'Ola';
  if (body.contains('atm')) return 'ATM';
  return 'UNKNOWN';
}
