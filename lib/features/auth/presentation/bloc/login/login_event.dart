import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String contactNumber;
  final String password;
  final String fcmToken;
  final String androidId;

  const LoginSubmitted({
    required this.contactNumber,
    required this.password,
    required this.fcmToken,
    required this.androidId,
  });

  @override
  List<Object?> get props => [contactNumber, password, fcmToken, androidId];
}
