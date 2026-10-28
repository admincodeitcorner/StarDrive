
import 'package:star_drive/features/dashboard/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.fatherName,
    required super.cnic,
    required super.contactNumber,
    required super.address,
    required super.role,
    required super.dob,
    required super.isActive,
    required super.profilePicPath,
    required super.passengerRating,
    required super.isDriver,
  });

  factory UserProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      fatherName: json['fatherName']?.toString() ?? '',
      cnic: json['cnic']?.toString() ?? '',
      contactNumber: json['contactNumber']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      dob: _parseDate(json['dob']),
      isActive: _parseBool(json['isActive']),
      profilePicPath: json['profilePicPath']?.toString(),
      passengerRating: (json['passengerRating'] as num?)?.toDouble() ?? 0.0,
      isDriver: _parseBool(json['isDriver']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is DateTime) return value;
    if (value == null || value.toString().isEmpty) return null;
    return DateTime.tryParse(value.toString());
  }

  static bool _parseBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase() == 'true';
  }
}