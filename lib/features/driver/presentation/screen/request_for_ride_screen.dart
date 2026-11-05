import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/driver/presentation/screen/widgets/ride_detail_bottom_sheet.dart';

import '../bloc/incoming_ride/incoming_ride_bloc.dart';
import '../bloc/send_offer/send_offer_bloc.dart';
import 'widgets/incoming_ride_card.dart';

class RequestForRideScreen extends StatelessWidget {
  const RequestForRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Ride Requests'),
        centerTitle: true,
      ),

      body: BlocBuilder<IncomingRideBloc, IncomingRideState>(
        builder: (context, state) {
          // Loading
          if (state is IncomingRideLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Loaded
          if (state is IncomingRideLoaded) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('No incoming ride requests'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,

              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },

              itemBuilder: (context, index) {
                final ride = state.requests[index];

                return IncomingRideCard(
                  // Passenger information
                  passengerName: ride.passengerName,
                  passengerRating: ride.passengerRating,

                  // Pickup information
                  pickupDistance: ride.pickupDistanceKm,

                  pickupAddress: ride.pickupName,

                  // Destination
                  destinationAddress: ride.dropName,

                  // Ride information
                  distanceKm: ride.distanceKm,
                  duration: '—',

                  // Fare information
                  offeredFare: ride.passengerOfferedFare,
                  suggestedFare: ride.suggestedFare,
                  minimumFare: ride.minimumOffer,

                  // Request expiry
                  secondsRemaining: ride.secondsRemaining,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (sheetContext) {
                        return RideDetailsBottomSheet(
                          ride: ride,

                          // Driver accepts the selected ride request.
                          onAccept: () {
                            debugPrint(
                              '========== RIDE FARE DETAILS ==========',
                            );

                            debugPrint(
                              'Passenger Offered Fare: ${ride.passengerOfferedFare}',
                            );

                            debugPrint('Minimum Fare: ${ride.minimumOffer}');

                            debugPrint('Suggested Fare: ${ride.suggestedFare}');

                            debugPrint(
                              '======================================',
                            );

                            context.read<SendOfferBloc>().add(
                              SendOfferRequested(
                                rideId: ride.requestId,
                                offeredFare: ride.passengerOfferedFare,
                              ),
                            );
                          },
                          // Close the bottom sheet when driver skips the request.
                          onSkip: () {
                            Navigator.pop(sheetContext);
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          // Error
          if (state is IncomingRideError) {
            return Center(child: Text(state.message));
          }

          // Initial state
          return const Center(
            child: Text('Waiting for incoming ride requests...'),
          );
        },
      ),
    );
  }
}
