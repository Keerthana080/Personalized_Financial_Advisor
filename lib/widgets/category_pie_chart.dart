// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
// // import '../models/category.dart';

// // class CategoryPieChart extends StatelessWidget {
// //   final Map<Category, double> data;

// //   const CategoryPieChart({super.key, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     if (data.isEmpty) {
// //       return const Center(child: Text('No spending data'));
// //     }

// //     // Filter valid values
// //     final filteredData = data.entries
// //         .where((e) => e.value > 0 && e.value.isFinite)
// //         .toList();

// //     if (filteredData.isEmpty) {
// //       return const Center(child: Text('No spending data'));
// //     }

// //     // IMPORTANT: total AFTER filtering
// //     final total =
// //         filteredData.fold(0.0, (sum, e) => sum + e.value);
// //     debugPrint('TOTAL = $total');
// //      debugPrint('DATA = $filteredData');
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Spending Breakdown',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 12),

// //             // 🔥 FIXED HEIGHT — NO AspectRatio
// //             SizedBox(
// //               height: 220,
// //               width:240,
// //               child: PieChart(
// //                 PieChartData(
// //                   sectionsSpace:
// //                       filteredData.length == 1 ? 0 : 2,
// //                   centerSpaceRadius: 0,
// //                   sections: filteredData.map((e) {
// //                     final percent =
// //                         (e.value / total * 100).toStringAsFixed(1);

// //                     return PieChartSectionData(
// //                       // 🔑 NORMALIZED VALUE
// //                       value: e.value / total,
// //                       title: '$percent%',
// //                       radius: 70,
// //                       color: _colorForCategory(e.key),
// //                       titleStyle: const TextStyle(
// //                         fontSize: 12,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ),

// //             const SizedBox(height: 12),

// //             // Legend
// //             Wrap(
// //               spacing: 12,
// //               runSpacing: 8,
// //               children: filteredData.map((e) {
// //                 return Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Container(
// //                       width: 10,
// //                       height: 10,
// //                       decoration: BoxDecoration(
// //                         color: _colorForCategory(e.key),
// //                         shape: BoxShape.circle,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 6),
// //                     Text(
// //                       e.key.name,
// //                       style: const TextStyle(fontSize: 12),
// //                     ),
// //                   ],
// //                 );
// //               }).toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Color _colorForCategory(Category c) {
// //     switch (c) {
// //       case Category.food:
// //         return Colors.orange;
// //       case Category.travel:
// //         return Colors.blue;
// //       case Category.shopping:
// //         return Colors.purple;
// //       case Category.bills:
// //         return Colors.red;
// //       case Category.education:
// //         return Colors.green;
// //       case Category.atm:
// //         return Colors.grey;
// //       case Category.income:
// //         return Colors.teal;
// //       case Category.other:
// //         return Colors.brown;
// //     }
// //   }
// // }
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import '../models/category.dart';

// class CategoryPieChart extends StatelessWidget {
//   final Map<Category, double> data;

//   const CategoryPieChart({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     if (data.isEmpty) {
//       return const Center(child: Text('No spending data'));
//     }

//     // Filter valid values
//     final filteredData = data.entries
//         .where((e) => e.value > 0 && e.value.isFinite)
//         .toList();

//     if (filteredData.isEmpty) {
//       return const Center(child: Text('No spending data'));
//     }

//     // IMPORTANT: total AFTER filtering
//     final total = filteredData.fold(0.0, (sum, e) => sum + e.value);
//     debugPrint('TOTAL = $total');
//     debugPrint('DATA = $filteredData');

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Spending Breakdown',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),

//             SizedBox(
//               height: 220,
//               width: 240,
//               child: PieChart(
//                 PieChartData(
//                   sectionsSpace: filteredData.length == 1 ? 0 : 2,
//                   centerSpaceRadius: 0,
//                   sections: filteredData.map((e) {
//                     final percent =
//                         (e.value / total * 100).toStringAsFixed(1);

//                     return PieChartSectionData(
//                       value: e.value / total,
//                       title: '$percent%',
//                       radius: 70,
//                       color: _colorForCategory(e.key),
//                       titleStyle: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             // Legend
//             Wrap(
//               spacing: 12,
//               runSpacing: 8,
//               children: filteredData.map((e) {
//                 return Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                         color: _colorForCategory(e.key),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       e.key.name,
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🎨 UPDATED FINCOACH PALETTE (ONLY THIS CHANGED)
//   Color _colorForCategory(Category c) {
//     switch (c) {
//       case Category.food:
//         return const Color(0xFFFFA726); // soft orange
//       case Category.travel:
//         return const Color(0xFF1E88E5); // finance blue
//       case Category.shopping:
//         return const Color(0xFF8E24AA); // purple
//       case Category.bills:
//         return const Color(0xFFE53935); // red
//       case Category.education:
//         return const Color(0xFF43A047); // green
//       case Category.atm:
//         return const Color(0xFF90A4AE); // neutral grey
//       case Category.income:
//         return const Color(0xFF26A69A); // teal
//       case Category.other:
//         return const Color(0xFF6D4C41); // brown
//     }
//   }
// }
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<Category, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No spending data',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final filteredData = data.entries
        .where((e) => e.value > 0 && e.value.isFinite)
        .toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Text(
          'No spending data',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final total = filteredData.fold(0.0, (sum, e) => sum + e.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending Breakdown',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),

        SizedBox(
          height: 220,
          width: 240,
          child: PieChart(
            PieChartData(
              sectionsSpace: filteredData.length == 1 ? 0 : 2,
              centerSpaceRadius: 0,
              sections: filteredData.map((e) {
                final percent =
                    (e.value / total * 100).toStringAsFixed(1);

                return PieChartSectionData(
                  value: e.value / total,
                  title: '$percent%',
                  radius: 70,
                  color: _colorForCategory(e.key),
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: filteredData.map((e) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _colorForCategory(e.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  e.key.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _colorForCategory(Category c) {
    switch (c) {
      case Category.food:
        return const Color.fromARGB(255, 211, 178, 226);
      case Category.travel:
        return const Color(0xFF1E88E5);
      case Category.shopping:
        return const Color(0xFF8E24AA);
      case Category.bills:
        return const Color(0xFFE53935);
      case Category.education:
        return const Color(0xFF43A047);
      case Category.atm:
        return const Color(0xFF90A4AE);
      case Category.income:
        return const Color(0xFF26A69A);
      case Category.other:
        return const Color.fromARGB(255, 96, 65, 110);
    }
  }
}