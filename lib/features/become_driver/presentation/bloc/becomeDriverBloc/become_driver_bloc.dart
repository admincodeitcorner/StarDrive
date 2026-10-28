import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/become_driver_usecase.dart';
import 'become_driver_event.dart';
import 'become_driver_state.dart';

class BecomeDriverBloc
    extends Bloc<BecomeDriverEvent, BecomeDriverState> {
  final BecomeDriverUseCase becomeDriverUseCase;

  BecomeDriverBloc(this.becomeDriverUseCase)
      : super(const BecomeDriverInitial()) {
    on<SubmitBecomeDriver>(_onSubmitBecomeDriver);
  }

  Future<void> _onSubmitBecomeDriver(
    SubmitBecomeDriver event,
    Emitter<BecomeDriverState> emit,
  ) async {
    emit(const BecomeDriverLoading());

    final result = await becomeDriverUseCase(event.request);

    result.fold(
      (failure) => emit(
        BecomeDriverFailure(failure.message),
      ),
      (driver) => emit(
        BecomeDriverSuccess(driver),
      ),
    );
  }
}