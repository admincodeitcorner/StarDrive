part of 'incoming_ride_bloc.dart';

sealed class IncomingRideEvent extends Equatable {
  const IncomingRideEvent();

  @override
  List<Object?> get props => [];
}

// Start listening for incoming ride requests.
final class StartIncomingRideListener extends IncomingRideEvent {}

// A new ride request is received from SignalR.
final class IncomingRideReceived extends IncomingRideEvent {
  final IncomingRideEntity ride;

  const IncomingRideReceived(this.ride);

  @override
  List<Object?> get props => [ride];
}

// Remove a ride after it is accepted or declined.
final class RemoveIncomingRide extends IncomingRideEvent {
  final String requestId;

  const RemoveIncomingRide(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

// Handle SignalR listener errors.
final class IncomingRideListenerFailed extends IncomingRideEvent {
  final String message;

  const IncomingRideListenerFailed(this.message);

  @override
  List<Object?> get props => [message];
}