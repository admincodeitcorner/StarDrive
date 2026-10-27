import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/data/dataresource/local/auth_local_data_storage.dart';
import 'package:star_drive/features/auth/domain/usecase/login_use_case.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final AuthLocalStorage authLocalStorage;

  LoginBloc(this.loginUseCase, this.authLocalStorage)
    : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final user = await loginUseCase(
        contactNumber: event.contactNumber,
        password: event.password,
        fcmToken: event.fcmToken,
        androidId: event.androidId,
      );
      await authLocalStorage.saveUser(user);

      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('401')) {
      return 'Invalid contact number or password.';
    }

    if (message.contains('SocketException')) {
      return 'Internet connection check karein.';
    }

    return message.replaceFirst('Exception: ', '');
  }
}
