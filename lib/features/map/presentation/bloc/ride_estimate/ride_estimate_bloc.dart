import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/map/presentation/bloc/ride_estimate/ride_estimate_event.dart';
import 'package:star_drive/features/map/presentation/bloc/ride_estimate/ride_estimate_state.dart';

import '../../../domain/usecase/ride_estimate_usecase.dart';

class RideEstimateBloc
    extends Bloc<RideEstimateEvent, RideEstimateState> {
  final GetRideEstimate getRideEstimate;

  RideEstimateBloc({
    required this.getRideEstimate,
  }) : super(const RideEstimateInitial()) {
    on<RideEstimateRequested>(_onRideEstimateRequested);
  }

  Future<void> _onRideEstimateRequested(
    RideEstimateRequested event,
    Emitter<RideEstimateState> emit,
  ) async {
    emit(const RideEstimateLoading());

    final result = await getRideEstimate(event.request);

    result.fold(
      (failure) => emit(
        RideEstimateFailure(failure.message),
      ),
      (estimate) => emit(
        RideEstimateSuccess(estimate),
      ),
    );
  }
}