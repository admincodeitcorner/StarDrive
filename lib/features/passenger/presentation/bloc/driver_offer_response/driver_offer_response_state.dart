part of 'driver_offer_response_bloc.dart';

enum DriverOfferResponseAction {
  accept,
  decline,
}

sealed class DriverOfferResponseState extends Equatable {
  const DriverOfferResponseState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any offer response action.
final class DriverOfferResponseInitial
    extends DriverOfferResponseState {}

/// Represents an ongoing accept or decline request.
final class DriverOfferResponseLoading
    extends DriverOfferResponseState {
  const DriverOfferResponseLoading({
    required this.action,
  });

  final DriverOfferResponseAction action;

  @override
  List<Object?> get props => [action];
}

/// Contains ride details returned after successful acceptance.
final class DriverOfferAccepted extends DriverOfferResponseState {
  const DriverOfferAccepted({
    required this.response,
  });

  final AcceptOfferResponseEntity response;

  @override
  List<Object?> get props => [response];
}

/// Represents successful decline of an incoming offer.
final class DriverOfferDeclined extends DriverOfferResponseState {
  const DriverOfferDeclined();
}

/// Represents a failed accept or decline operation.
final class DriverOfferResponseFailure
    extends DriverOfferResponseState {
  const DriverOfferResponseFailure({
    required this.message,
    required this.action,
  });

  final String message;
  final DriverOfferResponseAction action;

  @override
  List<Object?> get props => [
        message,
        action,
      ];
}