// services/ai_financial_context_builder.dart

import '../models/transaction_model.dart';
import '../models/category.dart';
import 'monthly_insights_service.dart';
import 'category_spend_service.dart';

class AiFinancialContextBuilder {
  static Map<String, dynamic> build({
    required List<TransactionModel> transactions,
    required double monthlyIncome,
  }) {
    // 1️⃣ Get existing insights
    final monthlyInsights = MonthlyInsightsService.calculate(transactions);
    final categorySpend = CategorySpendService.calculate(transactions);

    // 2️⃣ Derive missing values
    final totalSpend = monthlyInsights.totalSpend;
    final savings = monthlyIncome - totalSpend;
    final savingsPercent =
        monthlyIncome == 0 ? 0 : (savings / monthlyIncome) * 100;

    // 3️⃣ Convert category spend to readable format
    final Map<String, double> categoryData = {
      for (final entry in categorySpend.entries)
        entry.key.name: entry.value
    };

    // 4️⃣ Build final AI context
    return {
      "monthly_income": monthlyIncome,
      "total_spend": totalSpend,
      "previous_month_spend": monthlyInsights.previousMonthSpend,
      "percentage_change": monthlyInsights.percentageChange,
      "top_category": monthlyInsights.topCategory?.name,
      "savings": savings,
      "savings_percent": savingsPercent,
      "category_spend": categoryData,
    };
  }
}
