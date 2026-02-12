import 'package:hive_flutter/hive_flutter.dart';

import '../models/profile_settings.dart';
import '../models/transaction_model.dart';
import '../models/transaction_type.dart';

class SavingsService {
  /// 🔹 Monthly saved amount
  static double calculateMonthlySavings(List<TransactionModel> txs) {
    final profileBox = Hive.box<ProfileSettings>('profile');
    final profile = profileBox.get(0);

    if (profile == null) return 0;

    final income = profile.monthlyIncome;
    if (income <= 0) return 0;

    final now = DateTime.now();

    final monthlySpend = txs
        .where(
          (tx) =>
              tx.type == TransactionType.debit &&
              tx.date.month == now.month &&
              tx.date.year == now.year,
        )
        .fold<double>(0, (sum, tx) => sum + tx.amount);

    final saved = income - monthlySpend;

    // 🔒 Never show negative savings
    return saved < 0 ? 0 : saved;
  }

  /// 🔹 Total saved till date (simple version)
  static double calculateTotalSavings(List<TransactionModel> txs) {
    final profileBox = Hive.box<ProfileSettings>('profile');
    final profile = profileBox.get(0);

    if (profile == null) return 0;

    final income = profile.monthlyIncome;
    if (income <= 0) return 0;

    final totalMonths = _distinctMonths(txs);

    final totalIncome = income * totalMonths;

    final totalSpend = txs
        .where((tx) => tx.type == TransactionType.debit)
        .fold<double>(0, (sum, tx) => sum + tx.amount);

    final saved = totalIncome - totalSpend;

    return saved < 0 ? 0 : saved;
  }

  /// 🔹 Helper: count unique (year, month)
  static int _distinctMonths(List<TransactionModel> txs) {
    final months = <String>{};

    for (final tx in txs) {
      months.add('${tx.date.year}-${tx.date.month}');
    }

    return months.isEmpty ? 1 : months.length;
  }
}