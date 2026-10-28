
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_event.dart';

abstract class UserProfileEvent {
  const UserProfileEvent();
}

class UserProfileRequested extends UserProfileEvent {
  const UserProfileRequested();
}

class PhoneNumberUpdateRequested extends UserProfileEvent {
  final String contactNumber;
  final String otpCode;

  const PhoneNumberUpdateRequested({
    required this.contactNumber,
    required this.otpCode,
  });
}

class PhoneOtpSendRequested extends UserProfileEvent {
  final String contactNumber;

  const PhoneOtpSendRequested({
    required this.contactNumber,
  });
}

//history event

abstract class HistoryEvent {
  const HistoryEvent();
}
class HistoryRequested extends HistoryEvent {
  final int page;
  final int pageSize;

  const HistoryRequested({
    this.page = 1,
    this.pageSize = 20,
  });
}
