import 'package:geolocator/geolocator.dart';

abstract interface class LocationRepository {
  Future<Position> getCurrentLocation();

  Future<LocationPermission> checkPermission();

  Future<LocationPermission> requestPermission();

  Future<bool> isLocationServiceEnabled();

  Future<bool> openAppSettings();

  Future<bool> openLocationSettings();
}