import 'package:geolocator/geolocator.dart';
import 'package:star_drive/features/map/domain/usecase/map_usecase.dart';

abstract class MapEvents {}

class GetCurrentLocationEvent extends MapEvents {
  final MapUseCase mapUseCase;
  GetCurrentLocationEvent({required this.mapUseCase});

  Future<Position> getCurrentLocation() async {
    return await mapUseCase();
  }
}
