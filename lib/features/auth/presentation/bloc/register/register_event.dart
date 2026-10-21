import 'package:equatable/equatable.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class SendOtpRequested extends AuthEvent {
  final String contactNumber;
  final String? cnic;
  final OtpPurpose purpose;

  const SendOtpRequested({
    required this.contactNumber,
    required this.purpose,
    this.cnic,
  });

  @override
  List<Object?> get props => [contactNumber, cnic, purpose];
}

final class RegisterRequested extends AuthEvent {
  final String name;
  final String contactNumber;
  final String role;
  final String password;
  final String otpCode;
  final String fcmToken;
  final String androidId;

  final String? fatherName;
  final String? cnic;
  final String? address;
  final String? dob;

  const RegisterRequested({
    required this.name,
    required this.contactNumber,
    required this.role,
    required this.password,
    required this.otpCode,
    required this.fcmToken,
    required this.androidId,
    this.fatherName,
    this.cnic,
    this.address,
    this.dob,
  });

  @override
  List<Object?> get props => [
    name,
    contactNumber,
    role,
    password,
    otpCode,
    fcmToken,
    androidId,
    fatherName,
    cnic,
    address,
    dob,
  ];
}

final class VerifyOtpRequested extends AuthEvent {
  final String contactNumber;
  final OtpPurpose purpose;
  final String code;

  const VerifyOtpRequested({
    required this.contactNumber,
    required this.purpose,
    required this.code,
  });

  @override
  List<Object?> get props => [contactNumber, purpose, code];
}
