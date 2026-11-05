import 'package:geolocator/geolocator.dart';

abstract interface class LocationDataSource {
  Future<Position> getCurrentLocation();
  Future<LocationPermission> requestPermission();
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationPermissionDeniedException();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionPermanentlyDeniedException();
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );

  
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  @override
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }
}

class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException();
}

class LocationPermissionPermanentlyDeniedException
    implements Exception {
  const LocationPermissionPermanentlyDeniedException();
}