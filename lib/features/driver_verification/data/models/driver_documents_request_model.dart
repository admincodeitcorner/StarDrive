import 'package:dio/dio.dart';

import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';

class DriverDocumentsRequestModel {
  final String licenseNumber;
  final String licenseExpiryDate; // yyyy-MM-dd
  final DocumentFile licenseFrontPic;
  final DocumentFile licenseBackPic;
  final DocumentFile cnicFrontPic;
  final DocumentFile cnicBackPic;

  const DriverDocumentsRequestModel({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.licenseFrontPic,
    required this.licenseBackPic,
    required this.cnicFrontPic,
    required this.cnicBackPic,
  });

  factory DriverDocumentsRequestModel.fromEntity(DriverDocuments e) {
    return DriverDocumentsRequestModel(
      licenseNumber: e.licenseNumber,
      licenseExpiryDate: _formatDate(e.licenseExpiryDate),
      licenseFrontPic: e.licenseFrontPic,
      licenseBackPic: e.licenseBackPic,
      cnicFrontPic: e.cnicFrontPic,
      cnicBackPic: e.cnicBackPic,
    );
  }

  static String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static Future<MultipartFile> _file(DocumentFile f) =>
      MultipartFile.fromFile(f.path, filename: f.fileName);


  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'LicenseNumber': licenseNumber,
      'LicenseExpiryDate': licenseExpiryDate,
      'LicenseFrontPic': await _file(licenseFrontPic),
      'LicenseBackPic': await _file(licenseBackPic),
      'CnicFrontPic': await _file(cnicFrontPic),
      'CnicBackPic': await _file(cnicBackPic),
    });
  }
}