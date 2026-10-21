import 'package:star_drive/features/driver_verification/domain/entities/driver_documents_submitted_detail_response.dart';

class DriverDocumentsResponseModel extends DriverDocumentsSubmittedDetailResponse {
  const DriverDocumentsResponseModel({
    required super.id,
    required super.driverProfileId,
    required super.driverStatus,
    required super.licenseNumber,
    required super.licenseExpiryDate,
    required super.daysUntilLicenseExpiry,
    required super.licenseExpiringSoon,
    required super.licenseFrontPicPath,
    required super.licenseBackPicPath,
    required super.cnicFrontPicPath,
    required super.cnicBackPicPath,
    required super.createdAt,
    super.updatedAt,
  });

  /// Receives the `data` object of the API envelope.
  factory DriverDocumentsResponseModel.fromJson(Map<String, dynamic> json) {
    final updatedAt = json['updatedAt'] as String?;

    return DriverDocumentsResponseModel(
      id: (json['id'] as num).toInt(),
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      driverStatus: json['driverStatus'] as String,
      licenseNumber: json['licenseNumber'] as String,
      licenseExpiryDate: DateTime.parse(json['licenseExpiryDate'] as String),
      daysUntilLicenseExpiry: (json['daysUntilLicenseExpiry'] as num).toInt(),
      licenseExpiringSoon: json['licenseExpiringSoon'] as bool,
      licenseFrontPicPath: json['licenseFrontPicPath'] as String,
      licenseBackPicPath: json['licenseBackPicPath'] as String,
      cnicFrontPicPath: json['cnicFrontPicPath'] as String,
      cnicBackPicPath: json['cnicBackPicPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt),
    );
  }
}