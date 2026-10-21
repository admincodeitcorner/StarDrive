import 'package:equatable/equatable.dart';
import 'package:star_drive/features/auth/domain/entities/auth_user.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class OtpSent extends AuthState {
  final String contactNumber;
  final String cnic;
  final String devCode;
  final int expiresInSeconds;
  final int resendAfterSeconds;

  const OtpSent({
    required this.contactNumber,
    required this.cnic,
    required this.devCode,
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
  });

  @override
  List<Object?> get props => [
    contactNumber,
    cnic,
    devCode,
    expiresInSeconds,
    resendAfterSeconds,
  ];
}

class OtpVerified extends AuthState {
  @override
  List<Object?> get props => [];
}

final class AuthSuccess extends AuthState {
  final AuthUser user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
