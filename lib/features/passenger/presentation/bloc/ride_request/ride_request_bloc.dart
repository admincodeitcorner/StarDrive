import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/ride_request_response_entity.dart';
import '../../../domain/usecase/ride_request_usecase.dart';


part 'ride_request_event.dart';
part 'ride_request_state.dart';

class RideRequestBloc
    extends Bloc<RideRequestEvent, RideRequestState> {
  final RideRequestUseCase rideRequestUseCase;

  RideRequestBloc({
    required this.rideRequestUseCase,
  }) : super(RideRequestInitial()) {
    on<RideRequestSubmitted>(_onRideRequestSubmitted);
        on<RideRequestReset>(_onRideRequestReset);

  }

  Future<void> _onRideRequestSubmitted(
    RideRequestSubmitted event,
    Emitter<RideRequestState> emit,
  ) async {
      if (state is RideRequestLoading ||
      state is RideRequestSuccess) {
    return;
  }


    emit(RideRequestLoading());

    final result = await rideRequestUseCase.rideOffer(
      estimateId: event.estimateId,
      offerFare: event.offerFare,
    );

    result.fold(
      (failure) {
        emit(
          RideRequestFailure(message: failure.message),
        );
      },
      (response) {
        emit(
          RideRequestSuccess(rideRequest: response),
        );
      },
    );
  }
   void _onRideRequestReset(
    RideRequestReset event,
    Emitter<RideRequestState> emit,
  ) {
    debugPrint('RideRequestBloc: RESET EVENT RECEIVED');

    emit(RideRequestInitial());

    debugPrint('RideRequestBloc: STATE IS INITIAL');
  }
}