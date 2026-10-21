import 'package:dio/dio.dart';

import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_submission.dart';

class VehicleDetailsRequestModel {
  final String vehicleNumber;
  final String type;
  final String model;
  final String color;
  final int seatingCapacity;

  final DocumentFile vehiclePic;
  final DocumentFile vehicleFrontPic;
  final DocumentFile vehicleBackPic;

  final DocumentFile vehicleCardFrontPic;
  final DocumentFile vehicleCardBackPic;

  const VehicleDetailsRequestModel({
    required this.vehicleNumber,
    required this.type,
    required this.model,
    required this.color,
    required this.seatingCapacity,
    required this.vehiclePic,
    required this.vehicleFrontPic,
    required this.vehicleBackPic,
    required this.vehicleCardFrontPic,
    required this.vehicleCardBackPic,
  });

  factory VehicleDetailsRequestModel.fromEntity(VehicleDetailsSubmission v) {
    return VehicleDetailsRequestModel(
      vehicleNumber: v.vehicleNumber,
      type: v.type,
      model: v.model,
      color: v.color,
      seatingCapacity: v.seatingCapacity,
      vehiclePic: v.vehiclePic,
      vehicleFrontPic: v.vehicleFrontPic,
      vehicleBackPic: v.vehicleBackPic,
      vehicleCardFrontPic: v.vehicleCardFrontPic,
      vehicleCardBackPic: v.vehicleCardBackPic,
    );
  }

  static Future<MultipartFile> _file(DocumentFile file) {
    return MultipartFile.fromFile(file.path, filename: file.fileName);
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'VehicleNumber': vehicleNumber,
      'Type': type,
      'Model': model,
      'Color': color,
      'SeatingCapacity': seatingCapacity.toString(),
      'VehiclePic': await _file(vehiclePic),
      'VehicleFrontPic': await _file(vehicleFrontPic),

      'VehicleBacktPic': await _file(vehicleBackPic),
      'VehicleCardFrontPic': await _file(vehicleCardFrontPic),
      'VehicleCardBackPic': await _file(vehicleCardBackPic),
    });
  }
}
