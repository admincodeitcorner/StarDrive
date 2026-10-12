import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
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
        fcmToken,
        androidId,
      ];
}