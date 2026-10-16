import 'package:geolocator/geolocator.dart';

import '../../domain/repository/map_reposity.dart';
import '../datasource/location_data_source.dart';

class MapRepositoryImp implements MapRepository {
  final LocationDataSource _locationDataSource;
  MapRepositoryImp(this._locationDataSource);

  @override
  Future<Position> getCurrentLocation() async {
    return await _locationDataSource.getCurrentLocation();
  }
}
