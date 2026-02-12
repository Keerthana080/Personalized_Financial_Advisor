import 'dart:math';
import '../models/transaction_model.dart';
import '../models/transaction_type.dart';
import '../models/profile_settings.dart';

class HealthScoreService {
  /// ✅ MAIN HEALTH SCORE
  static int calculate(
    List<TransactionModel> transactions,
    ProfileSettings profile,
  ) {
    final now = DateTime.now();

    final expected = profile.expectedBudget;
    if (expected <= 0) return 100;

    final spent = monthlySpent(transactions);

    final ratio = spent / expected;
    final score = ((1 - ratio) * 100).round();

    return max(0, min(100, score));
  }

  /// ✅ MONTHLY SPENT (THIS WAS MISSING)
  static double monthlySpent(List<TransactionModel> transactions) {
    final now = DateTime.now();

    return transactions
        .where(
          (tx) =>
              tx.type == TransactionType.debit &&
              tx.date.month == now.month &&
              tx.date.year == now.year,
        )
        .fold<double>(0, (sum, tx) => sum + tx.amount);
  }
}