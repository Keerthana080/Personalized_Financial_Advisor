import '../models/transaction_model.dart';
import '../models/category.dart';

class CategorySpendService {
  static Map<Category, double> calculate(List<TransactionModel> txs) {
    final Map<Category, double> data = {};

    for (final tx in txs) {
      if (tx.type.name != 'debit') continue;

      data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
    }

    return data;
  }
}
