import '../../domain/entities/auth_user.dart';

class AuthResponseModel extends AuthUser {
  const AuthResponseModel({
    required super.id,
    required super.name,
    required super.fatherName,
    required super.cnic,
    required super.contactNumber,
    required super.address,
    required super.role,
    required super.dob,
    required super.isActive,
    required super.isApproved,
    required super.passengerRating,
    required super.isDriver,
     super.driverStatus,
    required super.totalEarning,
    required super.fcmToken,
    required super.androidId,
    required super.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
  return AuthResponseModel(
    id: (json['id'] as num).toInt(),
    name: json['name'] as String,
    fatherName: json['fatherName'] as String,
    cnic: json['cnic'] as String,
    contactNumber: json['contactNumber'] as String,
    address: json['address'] as String,
    role: json['role'] as String,
    dob: json['dob'] as String,
    isActive: json['isActive'] as bool,
    isApproved: json['isApproved'] as bool,
    passengerRating: (json['passengerRating'] as num).toDouble(),
    isDriver: json['isDriver'] as bool,

    // Null ya String dono handle honge.
    driverStatus: json['driverStatus'] as String?,

    totalEarning: (json['totalEarning'] as num).toDouble(),
    fcmToken: json['fcmToken'] as String,
    androidId: json['androidId'] as String,
    token: json['token'] as String,
  );
}
}