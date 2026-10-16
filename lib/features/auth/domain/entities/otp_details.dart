import 'package:equatable/equatable.dart';

class OtpDetails extends Equatable {
  final int expiresInSeconds;
  final int resendAfterSeconds;
  final String devCode;

  const OtpDetails({
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
    required this.devCode,
  });

  @override
  List<Object?> get props => [
        expiresInSeconds,
        resendAfterSeconds,
        devCode,
      ];
}