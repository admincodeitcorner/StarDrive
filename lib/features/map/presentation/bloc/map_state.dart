import 'package:geolocator/geolocator.dart';

class MapState {}

class MapInitial extends MapState {}

class MapLocationLoading extends MapState {}

class MapLocationSuccess extends MapState {
  final Position position;
  MapLocationSuccess({required this.position});
}

class MapLocationFailure extends MapState {
  final String message;
  MapLocationFailure({required this.message});
}
