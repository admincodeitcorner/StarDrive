import '../entities/ride_history.dart';

abstract class HistoryRepository {
  Future<RideHistory> getRideHistory({
    int page = 1,
    int pageSize = 20,
  });
}