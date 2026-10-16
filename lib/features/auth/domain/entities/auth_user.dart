import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final int id;
  final String name;
  final String contactNumber;
  final String role;
  final bool isActive;
  final bool isApproved;
  final double passengerRating;
  final bool isDriver;
  final double totalEarning;
  final String fcmToken;
  final String androidId;
  final String token;

   final String? fatherName;
  final String? cnic;
  final String? address;
  final String? dob;
  final String? driverStatus;

  const AuthUser({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.role,
    required this.isActive,
    required this.isApproved,
    required this.passengerRating,
    required this.isDriver,
    required this.totalEarning,
    required this.fcmToken,
    required this.androidId,
    required this.token,
    this.fatherName,
    this.cnic,
    this.address,
    this.dob,
    this.driverStatus,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        contactNumber,
        role,
        isActive,
        isApproved,
        passengerRating,
        isDriver,
        totalEarning,
        fcmToken,
        androidId,
        token,
        fatherName,
        cnic,
        address,
        dob,
        driverStatus,
      ];
}