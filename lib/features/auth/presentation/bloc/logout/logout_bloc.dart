import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/domain/usecase/logout_usecase.dart';


import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc(this.logoutUseCase) : super(const LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(const LogoutLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        emit(LogoutFailure(failure.message));
      },
      (_) {
        emit(const LogoutSuccess());
      },
    );
  }
}