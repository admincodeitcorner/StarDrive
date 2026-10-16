import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String contactNumber;
  final String otpCode;
  final String newPassword;

  const ResetPasswordSubmitted({
    required this.contactNumber,
    required this.otpCode,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [
        contactNumber,
        otpCode,
        newPassword,
      ];
}