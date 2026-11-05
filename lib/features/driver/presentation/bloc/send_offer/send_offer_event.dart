part of 'send_offer_bloc.dart';

abstract class SendOfferEvent extends Equatable {
  const SendOfferEvent();

  @override
  List<Object?> get props => [];
}

class SendOfferRequested extends SendOfferEvent {
  const SendOfferRequested({
    required this.rideId,
    required this.offeredFare,
  });

  final String rideId;
  final int offeredFare;

  @override
  List<Object?> get props => [
        rideId,
        offeredFare,
      ];
}