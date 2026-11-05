
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../domain/entities/incoming_ride_entity.dart';

/// Displays  bottom sheet when user click on an incoming ride card.

class RideDetailsBottomSheet extends StatelessWidget {
  const RideDetailsBottomSheet({
    super.key,
    required this.ride,
    required this.onAccept,
    required this.onSkip,
  });

  /// Complete ride information received from the parent screen.
  final IncomingRideEntity ride;

  /// Called when the driver accepts the ride request.
  final VoidCallback onAccept;

  /// Called when the driver skips the ride request.
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,

        /// Bottom Sheet visual appearance.
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Visual indicator showing that the sheet is draggable.
              _buildDragIndicator(),

              const SizedBox(height: 22),

              /// Section 1: Passenger information.
              _buildPassengerInformation(),

              const SizedBox(height: 18),

              const Divider(
                color: Color(0xFFE8EAF0),
                height: 1,
              ),

              const SizedBox(height: 20),

              /// Section 2: Pickup location.
              _buildLocationSection(
                icon: Icons.circle,
                iconColor: const Color(0xFF009B62),
                title: 'PICKUP LOCATION',
                address: ride.pickupName,
                subtitle:
                    '${ride.pickupDistanceKm.toStringAsFixed(1)} km away from you',
              ),

              const SizedBox(height: 20),

              /// Section 3: Destination location.
              _buildLocationSection(
                icon: Icons.location_on,
                iconColor: const Color(0xFFC51F2B),
                title: 'DESTINATION',
                address: ride.dropName,
              ),

              const SizedBox(height: 20),

              /// Section 4: Ride distance and estimated duration.
              _buildRideInformation(),

              const SizedBox(height: 20),

              /// Section 5: Fare breakdown.
              _buildFareInformation(),

              const SizedBox(height: 24),

              /// Section 6: Driver actions.
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the small drag indicator at the top of the sheet.
  Widget _buildDragIndicator() {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Displays passenger name, avatar and passenger rating.
  Widget _buildPassengerInformation() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFFFEADF),
          child: Text(
            ride.passengerName.isNotEmpty
                ? ride.passengerName[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ride.passengerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF182338),
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    ride.passengerRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF526078),
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Text(
                    'Passenger Rating',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a reusable pickup or destination location section.
  ///
  /// The same widget is used for both locations to avoid
  /// duplicating location-related UI code.
  Widget _buildLocationSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 17,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF182338),
                  height: 1.4,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF758096),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Displays total ride distance and estimated travel duration.
  Widget _buildRideInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F8),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Expanded(
            child: _buildInformationItem(
              icon: Icons.route,
              title: 'Ride Distance',
              value: '${ride.distanceKm.toStringAsFixed(1)} km',
            ),
          ),

          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFDDE1E8),
          ),

          Expanded(
            child: _buildInformationItem(
              icon: Icons.access_time,
              title: 'Estimated Time',
              value: '—',
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable information item for distance and duration.
  Widget _buildInformationItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),

        const SizedBox(height: 7),

        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF758096),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF182338),
          ),
        ),
      ],
    );
  }

  /// Displays the passenger's offered fare along with
  /// the system suggested fare and minimum acceptable fare.
  Widget _buildFareInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFE0CD),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PASSENGER OFFERED FARE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A7465),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'PKR ${ride.passengerOfferedFare}',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF182338),
            ),
          ),

          const SizedBox(height: 14),

          const Divider(
            color: Color(0xFFFFE0CD),
            height: 1,
          ),

          const SizedBox(height: 12),

          _buildFareRow(
            title: 'Suggested Fare',
            amount: ride.suggestedFare,
          ),

          const SizedBox(height: 9),

          _buildFareRow(
            title: 'Minimum Fare',
            amount: ride.minimumOffer,
          ),
        ],
      ),
    );
  }

  /// Reusable row for displaying fare amounts.
  Widget _buildFareRow({
    required String title,
    required int amount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF75665B),
          ),
        ),

        Text(
          'PKR $amount',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF182338),
          ),
        ),
      ],
    );
  }

  /// Builds Skip and Accept Ride buttons.
  ///
  /// Both actions are delegated to the parent screen
  /// through callbacks.
  Widget _buildActionButtons() {
    return Row(
      children: [
        /// Skip button.
        Expanded(
          child: OutlinedButton(
            onPressed: onSkip,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              minimumSize: const Size(0, 50),
              side: const BorderSide(
                color: Colors.red,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// Accept ride button.
        Expanded(
          child: ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Accept Ride',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
