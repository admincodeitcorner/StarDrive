import '../entities/incoming_ride_entity.dart';
import '../repositories/incoming_ride_repository.dart';

class ListenIncomingRidesUseCase {
  final IncomingRideRepository repository;

  ListenIncomingRidesUseCase({
    required this.repository,
  });

  Stream<IncomingRideEntity> call() {
    return repository.listenIncomingRides();
  }
}