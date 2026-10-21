import 'package:equatable/equatable.dart';
import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';

class VehicleDetailsSubmission extends Equatable {
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

  const VehicleDetailsSubmission({
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

  @override
  List<Object?> get props => [
        vehicleNumber,
        type,
        model,
        color,
        seatingCapacity,
        vehiclePic,
        vehicleFrontPic,
        vehicleBackPic,
      ];
}