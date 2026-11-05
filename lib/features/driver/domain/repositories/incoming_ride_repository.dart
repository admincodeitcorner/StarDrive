import '../entities/incoming_ride_entity.dart';

abstract class IncomingRideRepository {
  Stream<IncomingRideEntity> listenIncomingRides();
}