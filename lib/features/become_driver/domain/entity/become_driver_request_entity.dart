import 'package:equatable/equatable.dart';

class BecomeDriverRequestEntity extends Equatable {
  final String cnic;
  final String fatherName;
  final String address;
  final String dob;

  const BecomeDriverRequestEntity({
    required this.cnic,
    required this.fatherName,
    required this.address,
    required this.dob,
  });

  @override
  List<Object?> get props => [
        cnic,
        fatherName,
        address,
        dob,
      ];
}