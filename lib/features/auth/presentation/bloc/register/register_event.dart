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
     this.cnic,
     required this.purpose,
  });

  @override
  List<Object?> get props => [contactNumber, cnic];
}

final class RegisterRequested extends AuthEvent {
  final String name;
  final String fatherName;
  final String cnic;
  final String contactNumber;
  final String address;
  final String role;
  final String dob;
  final String password;
  final String otpCode;
  final String fcmToken;
  final String androidId;

  const RegisterRequested({
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.contactNumber,
    required this.address,
    required this.role,
    required this.dob,
    required this.password,
    required this.otpCode,
    required this.fcmToken,
    required this.androidId,
  });

  @override
  List<Object?> get props => [
        name,
        fatherName,
        cnic,
        contactNumber,
        address,
        role,
        dob,
        password,
        otpCode,
        fcmToken,
        androidId,
      ];
}
class VerifyOtpRequested extends AuthEvent {
  final String contactNumber;
  final OtpPurpose purpose;
  final String code;

  const VerifyOtpRequested({
    required this.contactNumber,
    required this.purpose,
    required this.code,
  });

  @override
  List<Object?> get props => [
    contactNumber,
    purpose,
    code,
  ];
}