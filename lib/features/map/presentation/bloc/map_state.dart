part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

final class MapInitial extends MapState {
  const MapInitial();
}

final class MapLocationLoading extends MapState {
  const MapLocationLoading();
}

final class MapPermissionRequired extends MapState {
  const MapPermissionRequired();
}

final class MapPermissionPermanentlyDenied extends MapState {
  const MapPermissionPermanentlyDenied();
}

final class MapLocationServiceDisabled extends MapState {
  const MapLocationServiceDisabled();
}

final class MapLocationSuccess extends MapState {
  final Position position;

  const MapLocationSuccess(this.position);

  @override
  List<Object?> get props => [position.latitude, position.longitude];
}

final class MapLocationFailure extends MapState {
  final String message;

  const MapLocationFailure(this.message);

  @override
  List<Object?> get props => [message];
}