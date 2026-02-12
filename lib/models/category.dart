import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
enum Category {
  @HiveField(0)
  food,

  @HiveField(1)
  travel,

  @HiveField(2)
  shopping,

  @HiveField(3)
  bills,

  @HiveField(4)
  education,

  @HiveField(5)
  atm,

  @HiveField(6)
  income,

  @HiveField(7)
  other,
}
