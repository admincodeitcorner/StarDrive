import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/driver_offline_usecase.dart';
import '../../../domain/usecase/driver_online_usecase.dart';
import 'driver_availability_event.dart';
import 'driver_availability_state.dart';

class DriverAvailabilityBloc
    extends Bloc<DriverAvailabilityEvent, DriverAvailabilityState> {
  final DriverOnlineUseCase onlineUseCase;
  final DriverOfflineUseCase offlineUseCase;

  DriverAvailabilityBloc({
    required this.onlineUseCase,
    required this.offlineUseCase,
  }) : super(const DriverAvailabilityState()) {
    on<SetDriverOnlineRequested>(_onSetOnline);
    on<SetDriverOfflineRequested>(_onSetOffline);
  }

  Future<void> _onSetOnline(
    SetDriverOnlineRequested event,
    Emitter<DriverAvailabilityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await onlineUseCase(lat: event.lat, lon: event.lon);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          message: failure.message,
          messageType: AvailabilityMessageType.failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isOnline: true,
          isLoading: false,
          message: 'You are online now!',
          messageType: AvailabilityMessageType.success,
        ),
      ),
    );
  }

  Future<void> _onSetOffline(
    SetDriverOfflineRequested event,
    Emitter<DriverAvailabilityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await offlineUseCase(lat: event.lat, lon: event.lon);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          message: failure.message,
          messageType: AvailabilityMessageType.failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isOnline: false,
          isLoading: false,
          message: 'You are offline now!',
          messageType: AvailabilityMessageType.success,
        ),
      ),
    );
  }
}