import 'package:geolocator/geolocator.dart';

class LocationDataSource {
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
