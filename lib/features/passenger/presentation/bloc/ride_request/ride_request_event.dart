part of 'ride_request_bloc.dart';

sealed class RideRequestEvent extends Equatable {
  const RideRequestEvent();

  @override
  List<Object> get props => [];
}

final class RideRequestSubmitted extends RideRequestEvent {
  final String estimateId;
final int offerFare;
  const RideRequestSubmitted({
    required this.estimateId, required this.offerFare,
  });

  @override
  List<Object> get props => [estimateId, offerFare];
}

class RideRequestReset extends RideRequestEvent {
  const RideRequestReset();
}