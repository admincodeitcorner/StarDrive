import 'package:equatable/equatable.dart';

class RideRequestResponseEntity extends Equatable {
  final String requestId;
  final int expiresInSeconds;
  final int driversNotified;

  const RideRequestResponseEntity({
    required this.requestId,
    required this.expiresInSeconds,
    required this.driversNotified,
  });

  @override
  List<Object?> get props => [requestId, expiresInSeconds, driversNotified];
}
