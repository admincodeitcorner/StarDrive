import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/data/model/reset_password_model.dart';
import 'package:star_drive/features/auth/domain/usecase/reset_password_usecase.dart';

import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc
    extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;

  ResetPasswordBloc({
    required this.resetPasswordUseCase,
  }) : super(const ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(const ResetPasswordLoading());

    try {
      final result = await resetPasswordUseCase(
        ResetPasswordRequestModel(
          contactNumber: event.contactNumber,
          otpCode: event.otpCode,
          newPassword: event.newPassword,
        ),
      );

      emit(ResetPasswordSuccess(result.message));
    } catch (e) {
      emit(
        ResetPasswordFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}