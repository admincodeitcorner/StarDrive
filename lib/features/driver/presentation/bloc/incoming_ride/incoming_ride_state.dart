part of 'incoming_ride_bloc.dart';

sealed class IncomingRideState extends Equatable {
  const IncomingRideState();

  @override
  List<Object> get props => [];
}

/// Initial state before the incoming ride listener starts.
final class IncomingRideInitial extends IncomingRideState {}

/// Indicates that the incoming ride listener is being initialized.
final class IncomingRideLoading extends IncomingRideState {}

/// Contains the list of incoming ride requests received from SignalR.
final class IncomingRideLoaded extends IncomingRideState {
  final List<IncomingRideEntity> requests;

  const IncomingRideLoaded({
    required this.requests,
  });

  @override
  List<Object> get props => [requests];
}

/// Represents an error while initializing or listening for ride requests.
final class IncomingRideError extends IncomingRideState {
  final String message;

  const IncomingRideError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}