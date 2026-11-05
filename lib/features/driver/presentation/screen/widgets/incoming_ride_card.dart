
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_colors.dart';

/// Displays a single incoming ride request.
///
/// This widget is reusable and receives all ride information
/// through constructor parameters. It does not directly access
/// APIs, SignalR, or BLoC.
///
/// Accept and Decline actions are handled by the parent screen
/// through callbacks.
class IncomingRideCard extends StatelessWidget {
  const IncomingRideCard({
    super.key,
    required this.passengerName,
    required this.passengerRating,
    required this.pickupDistance,
    
    required this.pickupAddress,
    required this.destinationAddress,
    required this.distanceKm,
    required this.duration,
    required this.offeredFare,
    required this.suggestedFare,
    required this.minimumFare,
    required this.secondsRemaining,
     required this.onTap,
    
    
  });

  // Passenger information
  final String passengerName;
  final double passengerRating;

  // Pickup location information
  final double pickupDistance;
  
  final String pickupAddress;

  // Destination information
  final String destinationAddress;

  // Ride distance and estimated travel duration
  final double distanceKm;
  final String duration;

  // Fare information received from the backend
  final int offeredFare;
  final int suggestedFare;
  final int minimumFare;

  // Remaining time before the ride request expires
  final int secondsRemaining;
final VoidCallback onTap;
  // Callback functions are provided by the parent screen.
  // This keeps UI separate from business logic.
  // final VoidCallback onAccept;
  // final VoidCallback onDecline;

  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // Adds internal spacing between the card border and its content.
        padding: const EdgeInsets.all(14),
      
        // Defines the card appearance.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Passenger information
            // Displays passenger image, name, rating and request timer.
            Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: const Color(0xFFF3E9E1),
      
                  // // Display network image when available.
                  // backgroundImage: passengerImage != null
                  //     ? NetworkImage(passengerImage!)
                  //     : null,
      
                  // Display passenger's initial when image is unavailable.
                  child: Text(
                          passengerName.isNotEmpty
                              ? passengerName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    
                ),
      
                const SizedBox(width: 10),
      
                // Expanded prevents the passenger name from
                // occupying space needed by rating and timer.
                Expanded(
                  child: Text(
                    passengerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF182338),
                    ),
                  ),
                ),
      
                const Icon(
                  Icons.star,
                  color: AppColors.primary,
                  size: 15,
                ),
      
                const SizedBox(width: 2),
      
                Text(
                  passengerRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      
                const SizedBox(width: 8),
      
                // Shows the remaining time for this ride request.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEADF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${secondsRemaining}s',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 12),
      
            // Separates passenger information from ride details.
            const Divider(
              height: 1,
              color: Color(0xFFE8EDFA),
            ),
      
            const SizedBox(height: 12),
      
            // 2. Pickup location information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Green indicator represents the pickup point.
                const Icon(
                  Icons.circle,
                  color: Color(0xFF009B62),
                  size: 13,
                ),
      
                const SizedBox(width: 9),
      
                // Expanded allows location information to use
                // the remaining available card width.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'PICKUP',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF00865A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
      
                          const SizedBox(width: 7),
      
                          // Displays how far the driver is from pickup.
                          Expanded(
                            child: Text(
                              '$pickupDistance km ',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF00865A),
                              ),
                            ),
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 3),
      
                      // Pickup address received in the ride request.
                      Text(
                        pickupAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF182338),
                        ),
                      ),
      
                      const SizedBox(height: 5),
      
                      // Displays total ride distance and estimated duration.
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F3FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.route,
                              size: 13,
                              color: Color(0xFF526078),
                            ),
      
                            const SizedBox(width: 5),
      
                            Text(
                              '${distanceKm.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF263449),
                              ),
                            ),
      
                            const SizedBox(width: 9),
      
                            const Text('•'),
      
                            const SizedBox(width: 9),
      
                            const Icon(
                              Icons.access_time,
                              size: 13,
                              color: Color(0xFF526078),
                            ),
      
                            const SizedBox(width: 4),
      
                            Text(
                              duration,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 9),
      
            // 3. Destination location information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Red indicator represents the destination point.
                const Icon(
                  Icons.stop_rounded,
                  color: Color(0xFFC51F2B),
                  size: 17,
                ),
      
                const SizedBox(width: 9),
      
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DESTINATION',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFC51F2B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
      
                      const SizedBox(height: 3),
      
                      // Destination address received from the backend.
                      Text(
                        destinationAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF182338),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 11),
      
            // 4. Fare information
            // Highlights the passenger's offered fare and
            // displays the system suggested and minimum fares.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OFFERED FARE',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF75665B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
      
                        const SizedBox(height: 2),
      
                        // Passenger's offered amount is the main
                        // fare information shown to the driver.
                        Text(
                          'PKR $offeredFare',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF182338),
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  // Additional fare information.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Suggested: $suggestedFare',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF75665B),
                        ),
                      ),
      
                      const SizedBox(height: 3),
      
                      Text(
                        'Min: $minimumFare',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF75665B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 10),
      
            // // 5. Ride request actions
            // // Both buttons trigger callbacks supplied by the parent.
            // Row(
            //   children: [
            //     // Decline button: handles the decline action.
            //     Expanded(
            //       child: OutlinedButton.icon(
            //         onPressed: onDecline,
            //         icon: const Icon(
            //           Icons.close,
            //           size: 17,
            //           color: Colors.red,
            //         ),
            //         label: const Text(
            //           'Decline',
            //           style: TextStyle(
            //             color: Colors.red,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //         style: OutlinedButton.styleFrom(
            //           minimumSize: const Size(0, 41),
            //           side: const BorderSide(
            //             color: borderColor,
            //           ),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(9),
            //           ),
            //         ),
            //       ),
            //     ),
      
            //     const SizedBox(width: 8),
      
            //     // Accept button: handles the accept action.
            //     // The offered fare is displayed on the button.
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: onAccept,
            //         icon: const Icon(
            //           Icons.bolt,
            //           size: 17,
            //           color: Colors.white,
            //         ),
            //         label: Text(
            //           'Accept PKR $offeredFare',
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontSize: 12,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: primaryColor,
            //           elevation: 0,
            //           minimumSize: const Size(0, 41),
            //           padding: const EdgeInsets.symmetric(horizontal: 8),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(9),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
