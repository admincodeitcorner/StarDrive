import 'package:star_drive/features/become_driver/domain/entity/become_driver_request_entity.dart';

class BecomeDriverRequestModel extends BecomeDriverRequestEntity {
  const BecomeDriverRequestModel({
    required super.cnic,
    required super.fatherName,
    required super.address,
    required super.dob,
  });

  factory BecomeDriverRequestModel.fromEntity(
    BecomeDriverRequestEntity entity,
  ) {
    return BecomeDriverRequestModel(
      cnic: entity.cnic,
      fatherName: entity.fatherName,
      address: entity.address,
      dob: entity.dob,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cnic': cnic.trim(),
      'fatherName': fatherName.trim(),
      'address': address.trim(),
      'dob': dob,
    };
  }
}