// import 'package:flutter/material.dart';
// import 'package:santexnika_crm/tools/appColors.dart';
// import 'package:santexnika_crm/widgets/sized_box.dart';
// import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';
//
// import '../../widget/pie_chart.dart';
//
// class StatisticDiogrammaPage extends StatefulWidget {
//   const StatisticDiogrammaPage({super.key});
//
//   @override
//   State<StatisticDiogrammaPage> createState() => _StatisticDiogrammaPageState();
// }
//
// class _StatisticDiogrammaPageState extends State<StatisticDiogrammaPage> {
//   List<String> name = [
//     "Eng kop sotilayotgan tovarlar",
//     "Eng kam sotilayotgan tovarlar",
//     "Foyda yoki zarar",
//     "Eng ko'p savdo qigan haridorlar",
//     "Eng yaxshi ishlayatagan ishchilar",
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         child: GridView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           // Set scroll direction to horizontal
//           itemCount: name.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: AppColors.primaryColor,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: AppColors.borderColor)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 40,
//                         width: double.infinity,
//                         color: AppColors.primaryColor,
//                         child: Center(
//                           child: TextWidget(
//                             txt: name[index],
//                           ),
//                         ),
//                       ),
//                       const Hg(),
//                       Container(
//                         height: 500,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const PieChartUI(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             // Set the height of each item
//             mainAxisExtent: 600,
//           ),
//         ),
//       ),
//     );
//   }
// }
