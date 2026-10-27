import 'package:equatable/equatable.dart';

class BecomeDriverResponseEntity extends Equatable {
    final String message;
  final int userId;
  final int driverProfileId;
  final bool isDriver;
  final String driverStatus;
  final String? rejectionReason;
  final bool isApproved;
  final String token;

  const BecomeDriverResponseEntity({
    required this.userId,
    required this.driverProfileId,
    required this.isDriver,
    required this.driverStatus,
    this.rejectionReason,
    required this.isApproved,
    required this.token, required this.message,
  });

  @override
  List<Object?> get props => [
    message,
        userId,
        driverProfileId,
        isDriver,
        driverStatus,
        rejectionReason,
        isApproved,
        token,
      ];
}