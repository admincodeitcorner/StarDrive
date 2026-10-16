import 'package:geolocator/geolocator.dart';

abstract interface class MapRepository {
  Future<Position> getCurrentLocation();
}
