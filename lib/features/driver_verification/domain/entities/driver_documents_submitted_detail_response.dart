import 'package:equatable/equatable.dart';

class DriverDocumentsSubmittedDetailResponse extends Equatable {
  final int id;
  final int driverProfileId;
  final String driverStatus;
  final String licenseNumber;
  final DateTime licenseExpiryDate;
  final int daysUntilLicenseExpiry;
  final bool licenseExpiringSoon;
  final String licenseFrontPicPath;
  final String licenseBackPicPath;
  final String cnicFrontPicPath;
  final String cnicBackPicPath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const  DriverDocumentsSubmittedDetailResponse({
    required this.id,
    required this.driverProfileId,
    required this.driverStatus,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.daysUntilLicenseExpiry,
    required this.licenseExpiringSoon,
    required this.licenseFrontPicPath,
    required this.licenseBackPicPath,
    required this.cnicFrontPicPath,
    required this.cnicBackPicPath,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        driverProfileId,
        driverStatus,
        licenseNumber,
        licenseExpiryDate,
        daysUntilLicenseExpiry,
        licenseExpiringSoon,
        licenseFrontPicPath,
        licenseBackPicPath,
        cnicFrontPicPath,
        cnicBackPicPath,
        createdAt,
        updatedAt,
      ];
}