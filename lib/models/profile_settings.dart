import 'package:hive/hive.dart';

part 'profile_settings.g.dart';

@HiveType(typeId: 5)
class ProfileSettings extends HiveObject {
  @HiveField(0)
  double monthlyIncome;

  @HiveField(1)
  double expectedBudget;

  @HiveField(2)
  bool smsSyncEnabled;

  @HiveField(3)
  bool notificationsEnabled;
  @HiveField(4) 
  DateTime? lastConfettiDate;
  ProfileSettings({
    required this.monthlyIncome,
    required this.expectedBudget,
    required this.smsSyncEnabled,
    required this.notificationsEnabled,
    
  });
}
