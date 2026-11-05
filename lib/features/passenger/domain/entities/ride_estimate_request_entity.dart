import 'package:equatable/equatable.dart';

class RideEstimateRequestEntity extends Equatable {
  final String vehicleType;
  final RideEstimateLocationEntity pickup;
  final RideEstimateLocationEntity drop;

  const RideEstimateRequestEntity({
    required this.vehicleType,
    required this.pickup,
    required this.drop,
  });

  @override
  List<Object?> get props => [vehicleType, pickup, drop];
}

class RideEstimateLocationEntity extends Equatable {
  final double lat;
  final double lon;
  final String name;

  const RideEstimateLocationEntity({
    required this.lat,
    required this.lon,
    required this.name,
  });

  @override
  List<Object?> get props => [lat, lon, name];
}