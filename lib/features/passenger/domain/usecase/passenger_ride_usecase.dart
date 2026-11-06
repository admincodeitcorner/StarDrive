import '../entities/passenger_ride_entity.dart';
import '../repository/passenger_ride_repository.dart';

class ListenNewRidesUseCase {
  final PassengerRideRepository repository;

  ListenNewRidesUseCase({
    required this.repository,
  });

  Future<Stream<PassengerOfferEntity>> call() {
    return repository.listenNewOffers();
  }
}