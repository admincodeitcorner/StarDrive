import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/become_driver/domain/usecase/onboard_usecase.dart';

import 'onboard_status_bloc_event.dart';
import 'onboard_status_bloc_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingStatusUseCase getOnboardingStatus;

  OnboardingBloc({
    required this.getOnboardingStatus,
  }) : super(OnboardingInitial()) {
    on<OnboardingStatusRequested>(_onStatusRequested);
  }

  Future<void> _onStatusRequested(
    OnboardingStatusRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    final result = await getOnboardingStatus();

    result.fold(
      (failure) => emit(
        OnboardingFailure(failure.message),
      ),
      (status) => emit(
        OnboardingSuccess(status),
      ),
    );
  }
}