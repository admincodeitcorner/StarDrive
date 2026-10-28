
import 'package:star_drive/features/dashboard/domain/entities/ride_history.dart';
import 'package:star_drive/features/dashboard/domain/entities/user_profile.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  UserProfileLoaded(this.userProfile);
}

class UserProfileFailure extends UserProfileState {
  final String message;

  UserProfileFailure(this.message);
}

class PhoneNumberUpdating extends UserProfileState {}

class PhoneNumberUpdateSuccess extends UserProfileState {}

class PhoneNumberUpdateFailure extends UserProfileState {
  final String message;

  PhoneNumberUpdateFailure(this.message);
}

class PhoneOtpSending extends UserProfileState {}

class PhoneOtpSent extends UserProfileState {}

class PhoneOtpSendFailure extends UserProfileState {
  final String message;

  PhoneOtpSendFailure(this.message);
}

//history event
abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistorySuccess extends HistoryState {
  final RideHistory history;

  const HistorySuccess(this.history);
}

class HistoryFailure extends HistoryState {
  final String message;

  const HistoryFailure(this.message);
}
