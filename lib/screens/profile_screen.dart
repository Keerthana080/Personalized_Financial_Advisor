import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/profile_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileSettings profile;

  bool editIncome = false;
  bool editBudget = false;

  final incomeCtrl = TextEditingController();
  final budgetCtrl = TextEditingController();

  // 🎨 COLORS
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color cardDark = Color(0xFF2E2F66);
  static const Color accent = Color(0xFFB79CFF);

  @override
  void initState() {
    super.initState();
    profile = Hive.box<ProfileSettings>('profile').get('me')!;
    incomeCtrl.text = profile.monthlyIncome.toStringAsFixed(0);
    budgetCtrl.text = profile.expectedBudget.toStringAsFixed(0);
  }

  void saveProfile() {
    profile.monthlyIncome =
        double.tryParse(incomeCtrl.text) ?? profile.monthlyIncome;

    profile.expectedBudget =
        double.tryParse(budgetCtrl.text) ?? profile.expectedBudget;

    profile.save();

    debugPrint(
      '💾 SAVED → income=${profile.monthlyIncome}, expectedBudget=${profile.expectedBudget}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved successfully')),
    );

    setState(() {
      editIncome = false;
      editBudget = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseDark,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 AVATAR + NAME
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: accent,
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Keerthana',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.edit, color: Colors.white70, size: 18),
                    ],
                  ),
                ],
              ),
            ),

            // 🧾 MAIN CARD (till bottom)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  // 💰 Monthly Income
                  _editableCard(
                    title: 'Monthly Income',
                    controller: incomeCtrl,
                    editing: editIncome,
                    onEdit: () => setState(() => editIncome = true),
                  ),

                  const SizedBox(height: 12),

                  // 🎯 Expected Budget
                  _editableCard(
                    title: 'Expected Monthly Budget',
                    controller: budgetCtrl,
                    editing: editBudget,
                    onEdit: () => setState(() => editBudget = true),
                  ),

                  const SizedBox(height: 16),

                  if (editIncome || editBudget)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: saveProfile,
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                    ),

                  const Divider(color: Colors.white24, height: 32),

                  // 🔔 SETTINGS
                  SwitchListTile(
                    activeColor: accent,
                    title: const Text(
                      'SMS Sync',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: profile.smsSyncEnabled,
                    onChanged: (v) {
                      setState(() {
                        profile.smsSyncEnabled = v;
                        profile.save();
                      });
                    },
                  ),

                  SwitchListTile(
                    activeColor: accent,
                    title: const Text(
                      'Notifications',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: profile.notificationsEnabled,
                    onChanged: (v) {
                      setState(() {
                        profile.notificationsEnabled = v;
                        profile.save();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD ----------------

  Widget _editableCard({
    required String title,
    required TextEditingController controller,
    required bool editing,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: baseDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        subtitle: editing
            ? TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              )
            : Text(
                '₹ ${controller.text}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        trailing: editing
            ? null
            : IconButton(
                icon: const Icon(Icons.edit, color: Colors.white70),
                onPressed: onEdit,
              ),
      ),
    );
  }
}