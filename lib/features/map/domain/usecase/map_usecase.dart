import 'package:geolocator/geolocator.dart';

import '../repository/map_reposity.dart';

class MapUseCase {
  MapUseCase(this._mapRepository);

  final MapRepository _mapRepository;

  Future<Position> call() async {
    return await _mapRepository.getCurrentLocation();
  }
}
