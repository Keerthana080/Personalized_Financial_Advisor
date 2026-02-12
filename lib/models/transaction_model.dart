import 'package:hive/hive.dart';
import 'transaction_type.dart';
import 'category.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  TransactionType type;

  @HiveField(2)
  String merchant;

  @HiveField(3)
  Category category;

  @HiveField(4)
  DateTime date;

  TransactionModel({
    required this.amount,
    required this.type,
    required this.merchant,
    required this.category,
    required this.date,
  });
}
