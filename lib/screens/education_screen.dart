import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Basics')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _EduCard(
            title: '50-30-20 Rule',
            text: 'Spend 50% on needs, 30% on wants, and save 20%.',
          ),
          _EduCard(
            title: 'Emergency Fund',
            text: 'Save at least 3 months of expenses for emergencies.',
          ),
          _EduCard(
            title: 'Track Small Expenses',
            text: 'Small daily spends add up quickly over a month.',
          ),
        ],
      ),
    );
  }
}

class _EduCard extends StatelessWidget {
  final String title;
  final String text;

  const _EduCard({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
