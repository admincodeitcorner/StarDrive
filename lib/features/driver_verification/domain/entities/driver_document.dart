import 'package:equatable/equatable.dart';
import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';



class DriverDocuments extends Equatable {
  final String licenseNumber;
  final DateTime licenseExpiryDate;
  final DocumentFile licenseFrontPic;
  final DocumentFile licenseBackPic;
  final DocumentFile cnicFrontPic;
  final DocumentFile cnicBackPic;

  const DriverDocuments({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.licenseFrontPic,
    required this.licenseBackPic,
    required this.cnicFrontPic,
    required this.cnicBackPic,
  });

  @override
  List<Object?> get props => [
        licenseNumber,
        licenseExpiryDate,
        licenseFrontPic,
        licenseBackPic,
        cnicFrontPic,
        cnicBackPic,
      ];
}