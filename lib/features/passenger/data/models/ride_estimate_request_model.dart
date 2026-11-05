
import '../../domain/entities/ride_estimate_request_entity.dart';

class RideEstimateRequestModel extends RideEstimateRequestEntity {
  const RideEstimateRequestModel({
    required super.vehicleType,
    required super.pickup,
    required super.drop,
  });

  factory RideEstimateRequestModel.fromEntity(
    RideEstimateRequestEntity entity,
  ) {
    return RideEstimateRequestModel(
      vehicleType: entity.vehicleType,
      pickup: entity.pickup,
      drop: entity.drop,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'pickup': {
        'lat': pickup.lat,
        'lon': pickup.lon,
        'name': pickup.name,
      },
      'drop': {
        'lat': drop.lat,
        'lon': drop.lon,
        'name': drop.name,
      },
    };
  }
}