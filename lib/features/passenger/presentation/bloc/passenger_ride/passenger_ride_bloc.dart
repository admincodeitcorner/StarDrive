import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../domain/entities/passenger_ride_entity.dart';
import '../../../domain/usecase/passenger_ride_usecase.dart';
import 'passenger_ride_event.dart';
import 'passenger_ride_state.dart';

class PassengerRideBloc
    extends Bloc<PassengerRideEvent, PassengerRideState> {
  PassengerRideBloc({
    required this.listenNewOffersUseCase,
  }) : super(const PassengerRideInitial()) {
    on<StartPassengerRideListening>(_onStartListening);

    on<PassengerNewOfferReceived>(_onNewOfferReceived);

    on<PassengerRideErrorOccurred>(_onErrorOccurred);
  }

  final ListenNewRidesUseCase listenNewOffersUseCase;

  StreamSubscription<PassengerOfferEntity>? _offerSubscription;

  final List<PassengerOfferEntity> _offers = [];

  bool _isListening = false;

  // Start listening to SignalR.
  Future<void> _onStartListening(
    StartPassengerRideListening event,
    Emitter<PassengerRideState> emit,
  ) async {
    if (_isListening) return;

    emit(const PassengerRideListening());

    try {
      final offerStream = await listenNewOffersUseCase();

      _isListening = true;

      await _offerSubscription?.cancel();

      _offerSubscription = offerStream.listen(
        (offer) {
          add(PassengerNewOfferReceived(offer));
        },
        onError: (error) {
          add(
            PassengerRideErrorOccurred(error.toString()),
          );
        },
      );
    } catch (e) {
      emit(
        PassengerRideError(message: e.toString()),
      );
    }
  }

  // Handle incoming driver offer.
  void _onNewOfferReceived(
    PassengerNewOfferReceived event,
    Emitter<PassengerRideState> emit,
  ) {
    final incomingOffer = event.offer;

    // Avoid duplicate offers for the same request and driver.
    final existingIndex = _offers.indexWhere(
      (offer) =>
          offer.requestId == incomingOffer.requestId &&
          offer.driverProfileId == incomingOffer.driverProfileId,
    );

    if (existingIndex != -1) {
      _offers[existingIndex] = incomingOffer;
    } else {
      _offers.add(incomingOffer);
    }

    emit(
      PassengerRideLoaded(
        offers: List.unmodifiable(_offers),
      ),
    );
  }

  // Handle stream errors.
  void _onErrorOccurred(
    PassengerRideErrorOccurred event,
    Emitter<PassengerRideState> emit,
  ) {
    emit(
      PassengerRideError(message: event.message),
    );
  }

  @override
  Future<void> close() async {
    await _offerSubscription?.cancel();

    _isListening = false;

    return super.close();
  }
}