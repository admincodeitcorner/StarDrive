part of 'send_offer_bloc.dart';

abstract class SendOfferState extends Equatable {
  const SendOfferState();

  @override
  List<Object?> get props => [];
}

class SendOfferInitial extends SendOfferState {}

class SendOfferLoading extends SendOfferState {}

class SendOfferSuccess extends SendOfferState {
  const SendOfferSuccess({
    this.response,
  });

  final Object? response;

  @override
  List<Object?> get props => [response];
}

class SendOfferFailure extends SendOfferState {
  const SendOfferFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}