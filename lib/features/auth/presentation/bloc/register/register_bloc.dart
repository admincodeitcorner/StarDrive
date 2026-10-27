import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/domain/entities/otp_details.dart';

import 'package:star_drive/features/auth/domain/usecase/register_use_case.dart';
import 'package:star_drive/features/auth/domain/usecase/send_otp_usecase.dart';
import 'package:star_drive/features/auth/domain/usecase/verified_otp_usecase.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_state.dart';

import '../../../data/dataresource/local/auth_local_data_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final SendOtpUsecase sendOtp;
  final VerifyOtpUseCase verifyOtpUseCase;
  final AuthLocalStorage authLocalStorage;   // NEW

  AuthBloc({
    required this.registerUser,
    required this.sendOtp,
    required this.verifyOtpUseCase,
    required this.authLocalStorage
  }) : super(const AuthInitial()) {
    on<SendOtpRequested>(_onSendOtp);
    on<RegisterRequested>(_onRegister);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  Future<void> _onSendOtp(
  SendOtpRequested event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoading());

  try {
    final result = await sendOtp(
      contactNumber: event.contactNumber,
      cnic: event.cnic,
      purpose: event.purpose,
    );

    result.fold(
      (failure) {
        
        emit(AuthFailure(failure.message));
      },
      (otpDetails) {
        emit(
          OtpSent(
            contactNumber: event.contactNumber,
            cnic: event.cnic ?? '',
            devCode: otpDetails.devCode,
            expiresInSeconds: otpDetails.expiresInSeconds,
            resendAfterSeconds: otpDetails.resendAfterSeconds,
          ),
        );
      },
    );
  } catch (e) {
    emit(AuthFailure(_readableMessage(e)));
  }
}

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await registerUser(
        name: event.name,
        fatherName: event.fatherName,
        cnic: event.cnic,
        contactNumber: event.contactNumber,
        address: event.address,
        role: event.role,
        dob: event.dob,
        password: event.password,
        otpCode: event.otpCode,
        fcmToken: event.fcmToken,
        androidId: event.androidId,
      );
             await result.fold(
        (failure) async => emit(AuthFailure(failure.message)),
        (user) async {
          await authLocalStorage.saveUser(user);
          emit(AuthSuccess(user));
        },
      );

      // emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(_readableMessage(e)));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await verifyOtpUseCase(
        contactNumber: event.contactNumber,
        purpose: event.purpose,
        code: event.code,
      );

      emit(OtpVerified());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  String _readableMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}
