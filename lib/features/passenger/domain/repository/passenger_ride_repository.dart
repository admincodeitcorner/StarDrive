
import '../entities/passenger_ride_entity.dart';

abstract class PassengerRideRepository {
  Future<Stream<PassengerOfferEntity>> listenNewOffers();
}