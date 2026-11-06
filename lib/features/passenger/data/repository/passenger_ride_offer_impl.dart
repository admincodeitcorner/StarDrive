import '../../domain/entities/passenger_ride_entity.dart';
import '../../domain/repository/passenger_ride_repository.dart';

import '../datasource/signalr/passenger_ride_offer.dart';
import '../models/passenger_ride_offer_model.dart';

class PassengerRideRepositoryImpl
    implements PassengerRideRepository {
  PassengerRideRepositoryImpl({
    required this.passengerRideListener,
  });

  final PassengerRideListener passengerRideListener;

  @override
  Future<Stream<PassengerOfferEntity>> listenNewOffers() async {
    await passengerRideListener.start();

    return passengerRideListener.incomingDriverRides.map(
      (json) => PassengerRideOfferModel.fromJson(json),
    );
  }
}