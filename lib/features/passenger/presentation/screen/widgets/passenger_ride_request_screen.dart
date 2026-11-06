import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:star_drive/core/di/injector.dart';

import 'package:star_drive/features/passenger/presentation/bloc/passenger_ride/passenger_ride_bloc.dart';
import 'package:star_drive/features/passenger/presentation/bloc/passenger_ride/passenger_ride_event.dart';
import 'package:star_drive/features/passenger/presentation/bloc/passenger_ride/passenger_ride_state.dart';

import 'package:star_drive/features/passenger/presentation/screen/widgets/ride_offer_widgets.dart';

import '../../bloc/driver_offer_response/driver_offer_response_bloc.dart';
import '../../bloc/ride_request/ride_request_bloc.dart';

class PassengerRideRequestScreen extends StatelessWidget {
  final int driverView;
  final int requestTime;
  final String requestId;

  const PassengerRideRequestScreen({
    super.key,
    required this.driverView,
    required this.requestTime, required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PassengerRideBloc>(
          // Starts listening for incoming driver offers.
          create: (_) =>
              sl<PassengerRideBloc>()..add(const StartPassengerRideListening()),
        ),

        BlocProvider<DriverOfferResponseBloc>(
          // Handles passenger acceptance and rejection of driver offers.
          create: (_) => sl<DriverOfferResponseBloc>(),
        ),
      ],
      child: BlocListener<DriverOfferResponseBloc, DriverOfferResponseState>(
        listener: (context, state) {
          // Handles successful driver offer acceptance.
          if (state is DriverOfferAccepted) {
            final acceptedRide = state.response;

            debugPrint('Ride Accepted: ${acceptedRide.id}');
            debugPrint('Passenger: ${acceptedRide.passengerName}');
            debugPrint('Driver: ${acceptedRide.driverName}');
            debugPrint('Vehicle: ${acceptedRide.vehicleNumber}');
            debugPrint('Fare: ${acceptedRide.fare}');

            _showMessage(context, 'Driver offer accepted successfully.');

            // Navigate to the active ride screen when its route is available.
          }
          // Handles successful offer rejection.
          else if (state is DriverOfferDeclined) {
            _showMessage(context, 'Driver offer declined successfully.');

            // Remove the declined offer from the passenger offer list here.
          }
          // Displays API or network errors.
          else if (state is DriverOfferResponseFailure) {
            _showMessage(context, state.message, isError: true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Finding Drivers'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Driver View: $driverView'),
                const SizedBox(height: 5),

                Text('Request Time: $requestTime'),
                const SizedBox(height: 20),

                const Text(
                  'Driver Offers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                // Displays progress while an offer response is being processed.
                BlocBuilder<DriverOfferResponseBloc, DriverOfferResponseState>(
                  builder: (context, state) {
                    if (state is DriverOfferResponseLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                Expanded(
                  child: BlocBuilder<PassengerRideBloc, PassengerRideState>(
                    builder: (context, state) {
                      // Displays the initial offer-search state.
                      if (state is PassengerRideInitial) {
                        return const Center(child: Text('Finding drivers...'));
                      }

                      // Displays progress while waiting for SignalR offers.
                      if (state is PassengerRideListening) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('Waiting for driver offers...'),
                            ],
                          ),
                        );
                      }

                      // Displays errors from passenger offer listening.
                      if (state is PassengerRideError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      // Displays offers received from available drivers.
                      if (state is PassengerRideLoaded) {

                      
                        if (state.offers.isEmpty) {
                          return const Center(
                            child: Text('No driver offers received yet.'),
                          );
                        }

                        return ListView.separated(
                          itemCount: state.offers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final offer = state.offers[index];

                            

                            return RideOfferWidgets(
                              driverName: offer.driverName,
                              currency: offer.currency,
                              fare: offer.fare,
                              driverRating: offer.driverRating,
                              totalRides: offer.totalRides,
                              vechileModel: offer.vehicleModel,

                              // Sends the selected driver's offer for acceptance.
                              onAccept: () {
                                context.read<DriverOfferResponseBloc>().add(
                                  AcceptOfferRequested(
                                    requestId: offer.requestId,
                                    driverProfileId: offer.driverProfileId,
                                  ),
                                );
                              },

                              // Sends the selected driver's offer for rejection.
                              onDecline: () {
                                context.read<DriverOfferResponseBloc>().add(
                                  DeclineOfferRequested(
                                    requestId: offer.requestId,
                                    driverProfileId: offer.driverProfileId,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Keeps ride cancellation available while waiting for offers.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Dispatch ride cancellation event
                      context.read<RideRequestBloc>().add(
                        RideRequestCancelled(requestId: requestId,),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Cancel Request'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Displays a consistent success or error message.
  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }
}
