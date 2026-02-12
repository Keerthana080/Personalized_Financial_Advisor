import 'package:hive/hive.dart';
import '../models/profile_settings.dart';
import '../models/transaction_model.dart';
import '../models/transaction_type.dart';

class StreakService {
  /// 🔥 Weekly streak (Mon → Today)
  static int calculateWeeklyStreak(List<TransactionModel> txs) {
    final profileBox = Hive.box<ProfileSettings>('profile');
    final profile = profileBox.get('me');

    if (profile == null || profile.expectedBudget <= 0) {
      return 0;
    }

    final dailyLimit = profile.expectedBudget / 30;
    final now = DateTime.now();

    // Monday of current week
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    int streak = 0;

    for (int i = 0; i <= now.weekday - 1; i++) {
      final day = startOfWeek.add(Duration(days: i));

      final spentThatDay = txs
          .where(
            (tx) =>
                tx.type == TransactionType.debit &&
                tx.date.year == day.year &&
                tx.date.month == day.month &&
                tx.date.day == day.day,
          )
          .fold(0.0, (sum, tx) => sum + tx.amount);

      if (spentThatDay <= dailyLimit) {
        streak++;
      } else {
        break; // ❌ streak broken
      }
    }

    return streak;
  }
}