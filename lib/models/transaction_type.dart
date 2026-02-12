import 'package:hive/hive.dart';

part 'transaction_type.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  credit,

  @HiveField(1)
  debit,
}
