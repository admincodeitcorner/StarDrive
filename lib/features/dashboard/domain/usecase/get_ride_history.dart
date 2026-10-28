

import 'package:star_drive/features/dashboard/domain/entities/ride_history.dart';
import 'package:star_drive/features/dashboard/domain/repository/ride_history_repository.dart';

class GetRideHistory {
  final HistoryRepository repository;

  GetRideHistory(this.repository);

  Future<RideHistory> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.getRideHistory(
      page: page,
      pageSize: pageSize,
    );
  }
}
