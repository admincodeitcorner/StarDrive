import 'package:equatable/equatable.dart';

import '../../../domain/entities/passenger_ride_entity.dart';


abstract class PassengerRideState extends Equatable {
  const PassengerRideState();

  @override
  List<Object?> get props => [];
}

class PassengerRideInitial extends PassengerRideState {
  const PassengerRideInitial();
}

class PassengerRideListening extends PassengerRideState {
  const PassengerRideListening();
}

class PassengerRideLoaded extends PassengerRideState {
  final List<PassengerOfferEntity> offers;

  const PassengerRideLoaded({
    required this.offers,
  });

  @override
  List<Object?> get props => [offers];
}

class PassengerRideError extends PassengerRideState {
  final String message;

  const PassengerRideError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}