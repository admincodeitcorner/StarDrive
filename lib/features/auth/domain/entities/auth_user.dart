import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final int id;
  final String name;
  final String fatherName;
  final String cnic;
  final String contactNumber;
  final String address;
  final String role;
  final String dob;
  final bool isActive;
  final bool isApproved;
  final double passengerRating;
  final bool isDriver;
  final String driverStatus;
  final double totalEarning;
  final String fcmToken;
  final String androidId;
  final String token;

  const AuthUser({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.contactNumber,
    required this.address,
    required this.role,
    required this.dob,
    required this.isActive,
    required this.isApproved,
    required this.passengerRating,
    required this.isDriver,
    required this.driverStatus,
    required this.totalEarning,
    required this.fcmToken,
    required this.androidId,
    required this.token,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fatherName,
        cnic,
        contactNumber,
        address,
        role,
        dob,
        isActive,
        isApproved,
        passengerRating,
        isDriver,
        driverStatus,
        totalEarning,
        fcmToken,
        androidId,
        token,
      ];
}