import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 4)
class GoalModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double targetAmount;

  @HiveField(2)
  double savedAmount;

  @HiveField(3)
  double priorityPercent; // 🔥 NEW (0–100)

  GoalModel({
    required this.title,
    required this.targetAmount,
    required this.priorityPercent,
    this.savedAmount = 0,
  });
}