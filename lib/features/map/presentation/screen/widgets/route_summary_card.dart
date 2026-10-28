import 'package:flutter/material.dart';

class RouteSummaryCard extends StatelessWidget {
  final String pickupName;
  final String destinationName;
  final int estimatedMinutes;
  final double distanceKm;

  const RouteSummaryCard({
    super.key,
    required this.pickupName,
    required this.destinationName,
    required this.estimatedMinutes,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: .center,
          children: [
            Text('From: $pickupName'),
            Text('To: $destinationName'),
            Text('${distanceKm.toStringAsFixed(1)} km'),
            Text('$estimatedMinutes minutes'),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class RouteSummaryCard extends StatelessWidget {
//   final String pickupName;
//   final String destinationName;
//   final int estimatedMinutes;
//   final double distanceKm;

//   const RouteSummaryCard({
//     super.key,
//     required this.pickupName,
//     required this.destinationName,
//     required this.estimatedMinutes,
//     required this.distanceKm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 60,
//       left: 16,
//       right: 16,
//       child: SafeArea(
//         bottom: false,
//         child: Material(
//           color: Colors.white,
//           elevation: 6,
//           borderRadius: BorderRadius.circular(22),
//           clipBehavior: Clip.antiAlias,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Pickup location
//                 _LocationRow(
//                   icon: Icons.person_pin_circle,
//                   iconColor: Colors.black87,
//                   title: pickupName,
//                   trailing: const Text(
//                     'Pickup',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),

//                 const Padding(
//                   padding: EdgeInsets.only(left: 36),
//                   child: Divider(height: 18),
//                 ),

//                 // Destination location
//                 _LocationRow(
//                   icon: Icons.flag,
//                   iconColor: Colors.black87,
//                   title: destinationName,
//                   trailing: const Icon(
//                     Icons.add,
//                     size: 24,
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // Distance and duration
//                 Padding(
//                   padding: const EdgeInsets.only(left: 36),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.route,
//                         size: 16,
//                         color: Colors.black54,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         '${distanceKm.toStringAsFixed(1)} km',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       const Icon(
//                         Icons.access_time,
//                         size: 16,
//                         color: Colors.black54,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(
//                         '$estimatedMinutes min',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _LocationRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final Widget trailing;

//   const _LocationRow({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 25, color: iconColor),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Text(
//             title,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         trailing,
//       ],
//     );
//   }
// }
