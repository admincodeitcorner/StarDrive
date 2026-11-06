part of 'driver_offer_response_bloc.dart';

sealed class DriverOfferResponseEvent extends Equatable {
  const DriverOfferResponseEvent();

  @override
  List<Object?> get props => [];
}

/// Requests acceptance of an incoming ride offer.
final class AcceptOfferRequested extends DriverOfferResponseEvent {
  const AcceptOfferRequested({
    required this.requestId,
    required this.driverProfileId,
  });

  final String requestId;
  final int driverProfileId;

  @override
  List<Object?> get props => [
        requestId,
        driverProfileId,
      ];
}

/// Requests rejection of an incoming ride offer.
final class DeclineOfferRequested extends DriverOfferResponseEvent {
  const DeclineOfferRequested({
    required this.requestId,
    required this.driverProfileId,
  });

  final String requestId;
  final int driverProfileId;

  @override
  List<Object?> get props => [
        requestId,
        driverProfileId,
      ];
}