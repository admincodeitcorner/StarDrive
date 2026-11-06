part of 'ride_request_bloc.dart';

sealed class RideRequestState extends Equatable {
  const RideRequestState();

  @override
  List<Object?> get props => [];
}

final class RideRequestInitial extends RideRequestState {}

final class RideRequestLoading extends RideRequestState {}

final class RideRequestSuccess extends RideRequestState {
  final RideRequestResponseEntity rideRequest;

  const RideRequestSuccess({
    required this.rideRequest,
  });

  @override
  List<Object?> get props => [rideRequest];
}

final class RideRequestFailure extends RideRequestState {
  final String message;

  const RideRequestFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

final class RideRequestCancelling extends RideRequestState {
  const RideRequestCancelling();
}

final class RideRequestCancelSuccess extends RideRequestState {
  const RideRequestCancelSuccess();
}

final class RideRequestCancelFailure extends RideRequestState {
  final String message;

  const RideRequestCancelFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}