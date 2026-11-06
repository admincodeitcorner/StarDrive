import 'package:flutter/material.dart';

import '../../../../../core/constant/app_colors.dart';

class RideOfferWidgets extends StatelessWidget {
  const RideOfferWidgets({
    super.key,
    required this.driverName,
    required this.currency,
    required this.fare,
    required this.driverRating,
    required this.totalRides,
    this.onAccept,
    this.onDecline,
    required this.vechileModel,
  });
  final String driverName;
  final String currency;
  final int fare;
  final double driverRating;
  final int totalRides;
  final String vechileModel;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          //Amount

          Text('$currency ${fare.toString()}'),
          // Driver Info
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
                  driverName.isNotEmpty
                      ? driverName[0].toUpperCase()
                      : 'User',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        driverRating.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$totalRides rides',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    vechileModel,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          //Accept * Decline buttons
          Row(
            children: [
              // Decline button: handles the decline action.
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDecline,
                  icon: const Icon(Icons.close, size: 17, color: Colors.red),
                  label: const Text(
                    'Decline',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 41),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              //     // Accept button: handles the accept action.

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.bolt, size: 17, color: Colors.white),
                  label: Text(
                    'Accept',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: const Size(0, 41),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
