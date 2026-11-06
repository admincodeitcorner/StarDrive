import 'package:equatable/equatable.dart';

import '../../../domain/entities/passenger_ride_entity.dart';

abstract class PassengerRideEvent extends Equatable {
  const PassengerRideEvent();

  @override
  List<Object?> get props => [];
}

// Start listening to SignalR NewOffer events.
class StartPassengerRideListening extends PassengerRideEvent {
  const StartPassengerRideListening();
}

// New offer received from SignalR.
class PassengerNewOfferReceived extends PassengerRideEvent {
  final PassengerOfferEntity offer;

  const PassengerNewOfferReceived(this.offer);

  @override
  List<Object?> get props => [offer];
}

// Stream error.
class PassengerRideErrorOccurred extends PassengerRideEvent {
  final String message;

  const PassengerRideErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}