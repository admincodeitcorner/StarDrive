import 'package:equatable/equatable.dart';

abstract class DriverAvailabilityEvent extends Equatable {
  const DriverAvailabilityEvent();

  @override
  List<Object?> get props => [];
}

class SetDriverOnlineRequested extends DriverAvailabilityEvent {
  final double lat;
  final double lon;

  const SetDriverOnlineRequested({
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [lat, lon];
}

class SetDriverOfflineRequested extends DriverAvailabilityEvent {
  final double lat;
  final double lon;

  const SetDriverOfflineRequested({
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [lat, lon];
}