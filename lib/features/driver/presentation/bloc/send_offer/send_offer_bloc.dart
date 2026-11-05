import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecase/send_offer_usecase.dart';


part 'send_offer_event.dart';
part 'send_offer_state.dart';

class SendOfferBloc extends Bloc<SendOfferEvent, SendOfferState> {
  SendOfferBloc({
    required this.sendOfferUseCase,
  }) : super(SendOfferInitial()) {
    on<SendOfferRequested>(_onSendOfferRequested);
  }

  final SendOfferUseCase sendOfferUseCase;

  Future<void> _onSendOfferRequested(
    SendOfferRequested event,
    Emitter<SendOfferState> emit,
  ) async {
    emit(SendOfferLoading());

    final result = await sendOfferUseCase(
      rideId: event.rideId,
      offeredFare: event.offeredFare,
    );

    result.fold(
      (failure) {
        emit(
          SendOfferFailure(
            message: failure.toString(),
          ),
        );
      },
      (response) {
        emit(
          SendOfferSuccess(
            response: response,
          ),
        );
      },
    );
  }
}