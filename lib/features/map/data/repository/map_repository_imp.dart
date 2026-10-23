import 'package:geolocator/geolocator.dart';
import 'package:star_drive/features/map/data/datasource/location_data_source.dart';
import 'package:star_drive/features/map/domain/repository/map_reposity.dart';


class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<Position> getCurrentLocation() =>
      dataSource.getCurrentLocation();

  @override
  Future<LocationPermission> checkPermission() =>
      dataSource.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      dataSource.requestPermission();

  @override
  Future<bool> isLocationServiceEnabled() =>
      dataSource.isLocationServiceEnabled();

  @override
  Future<bool> openAppSettings() =>
      dataSource.openAppSettings();

  @override
  Future<bool> openLocationSettings() =>
      dataSource.openLocationSettings();
}