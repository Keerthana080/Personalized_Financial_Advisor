import 'package:flutter/material.dart';
import '../widgets/weeklyview_widget.dart';
import '../widgets/monthlyview_widget.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  bool showWeekly = true;

  // 🎨 Same palette as Weekly / Monthly
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color accent = Color(0xFFB79CFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseDark,

      // 🧾 APP BAR
      appBar: AppBar(
        backgroundColor: baseDark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Insights',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // 🔁 WEEKLY / MONTHLY TOGGLE (THEMED)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ToggleButtons(
              isSelected: [showWeekly, !showWeekly],
              onPressed: (i) {
                setState(() => showWeekly = i == 0);
              },
              borderRadius: BorderRadius.circular(14),
              fillColor: accent,
              selectedColor: Colors.white,
              color: Colors.white70,
              borderColor: accent,
              selectedBorderColor: accent,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Weekly',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'Monthly',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 📊 CONTENT
          Expanded(
            child: showWeekly
                ? const WeeklyView()
                : const MonthlyView(),
          ),
        ],
      ),
    );
  }
}