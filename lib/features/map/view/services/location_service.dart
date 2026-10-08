import 'package:geolocator/geolocator.dart';

class LocationService {

  
  Future<bool> checkPermission() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();


    print('Location service enabled: $serviceEnabled');

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    print('Current permission: $permission');

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      print('Permission after request: $permission');
    }

    if (permission == LocationPermission.denied) {
      print('Location permission denied');
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied');
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();

      if (!hasPermission) {
        print('Location permission/service not available');
        return null;
      }

      print('Getting current location...');

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      print(
        'GPS Location: '
        '${position.latitude}, ${position.longitude}',
      );

      return position;
    } catch (e) {
      print('Location error: $e');
      return null;
    }
  }
}