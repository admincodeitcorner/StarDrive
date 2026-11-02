import 'package:equatable/equatable.dart';

enum AvailabilityMessageType { none, success, failure }

class DriverAvailabilityState extends Equatable {
  final bool isOnline;
  final bool isLoading;
  final String? message;
  final AvailabilityMessageType messageType;

  const DriverAvailabilityState({
    this.isOnline = false,
    this.isLoading = false,
    this.message,
    this.messageType = AvailabilityMessageType.none,
  });

  DriverAvailabilityState copyWith({
    bool? isOnline,
    bool? isLoading,
    String? message,
    AvailabilityMessageType? messageType,
  }) {
    return DriverAvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      isLoading: isLoading ?? this.isLoading,
      // message ko hamesha overwrite karte hain taake purana message na rahe
      message: message,
      messageType: messageType ?? AvailabilityMessageType.none,
    );
  }

  @override
  List<Object?> get props => [isOnline, isLoading, message, messageType];
}