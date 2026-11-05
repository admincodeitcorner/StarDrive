part of 'map_bloc.dart';


sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

final class InitializeMapEvent extends MapEvent {
  const InitializeMapEvent();
}

final class RequestLocationPermissionEvent extends MapEvent {
  const RequestLocationPermissionEvent();
}

final class RetryLocationEvent extends MapEvent {
  const RetryLocationEvent();
}

final class OpenAppSettingsEvent extends MapEvent {
  const OpenAppSettingsEvent();
}

final class OpenLocationSettingsEvent extends MapEvent {
  const OpenLocationSettingsEvent();
}