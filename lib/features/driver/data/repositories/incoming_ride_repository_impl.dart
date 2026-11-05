import 'package:star_drive/features/driver/data/datasource/signalr/driver_ride_listener.dart';

import '../../domain/entities/incoming_ride_entity.dart';
import '../../domain/repositories/incoming_ride_repository.dart';
import '../models/incoming_ride_model.dart';

class IncomingRideRepositoryImpl implements IncomingRideRepository {
  IncomingRideRepositoryImpl({
    required this.driverRideListener,
  });

  final DriverRideListener driverRideListener;

  @override
  Stream<IncomingRideEntity> listenIncomingRides() {
    return driverRideListener.incomingRides.map(
      (json) => IncomingRideModel.fromJson(json),
    );
  }
}