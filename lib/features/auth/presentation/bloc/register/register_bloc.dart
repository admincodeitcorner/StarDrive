import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/domain/usecase/register_use_case.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;

  AuthBloc({
    required this.registerUser,
  }) : super(const AuthInitial()) {
    on<RegisterRequested>(_onRegister);
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await registerUser(
        name: event.name,
        fatherName: event.fatherName,
        cnic: event.cnic,
        contactNumber: event.contactNumber,
        address: event.address,
        role: event.role,
        dob: event.dob,
        password: event.password,
        fcmToken: event.fcmToken,
        androidId: event.androidId,
      );

      emit(AuthSuccess(user));
    } on DioException catch (error) {
      final body = error.response?.data;
      final message = body is Map<String, dynamic>
          ? body['message']?.toString() ??
              'Registration failed.'
          : 'Unable to connect to the server.';

      emit(AuthFailure(message));
    } on FormatException {
      emit(
        const AuthFailure('Invalid server response.'),
      );
    } catch (e) {
      emit(
         AuthFailure(
          e.toString()
        ),
      );
    }
  }
}