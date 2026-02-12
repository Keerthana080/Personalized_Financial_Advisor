import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/goal_model.dart';

class AddGoalSheet extends StatefulWidget {
  const AddGoalSheet({super.key});

  @override
  State<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<AddGoalSheet> {
  final titleCtrl = TextEditingController();
  final targetCtrl = TextEditingController();
  final priorityCtrl = TextEditingController();

  void saveGoal() {
    final title = titleCtrl.text.trim();
    final target = double.tryParse(targetCtrl.text);
    final priority = double.tryParse(priorityCtrl.text);

    if (title.isEmpty || target == null || priority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    Hive.box<GoalModel>('goals').add(
      GoalModel(
        title: title,
        targetAmount: target,
        savedAmount: 0,
        priorityPercent: priority,
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label,
      {String? helper, String? prefix}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      prefixText: prefix,
      labelStyle: const TextStyle(color: Colors.white),
      helperStyle: const TextStyle(color: Colors.white60),
      prefixStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 32, 34, 73), // dark background
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: _inputDecoration('Goal name'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: _inputDecoration(
                'Target amount',
                prefix: '₹ ',
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: priorityCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: _inputDecoration(
                'Priority (%)',
                helper: 'How much of savings goes to this goal',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Save Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
