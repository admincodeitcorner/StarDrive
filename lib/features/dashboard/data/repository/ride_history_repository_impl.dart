

import 'package:star_drive/features/dashboard/data/datasource/ride_history_remote_datasource.dart';
import 'package:star_drive/features/dashboard/domain/entities/ride_history.dart';
import 'package:star_drive/features/dashboard/domain/repository/ride_history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<RideHistory> getRideHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await remoteDataSource.getRideHistory(
      page: page,
      pageSize: pageSize,
    );

    return RideHistory(
      code: response.code,
      message: response.message,
      rides: response.data.rides.map((ride) {
        return RideHistoryItem(
          rideId: ride.rideId,
          yourRole: ride.yourRole,
          status: ride.status,
          rideDate: ride.rideDate,
          pickupName: ride.pickupName,
          dropName: ride.dropName,
          fare: ride.fare,
          commissionAmount: ride.commissionAmount,
          driverEarning: ride.driverEarning,
          driverRating: ride.driverRating,
          passengerRating: ride.passengerRating,
          otherPartyName: ride.otherPartyName,
          vehicleNumber: ride.vehicleNumber,
          cancelledBy: ride.cancelledBy,
          cancelReason: ride.cancelReason,
        );
      }).toList(),
      page: response.data.page,
      pageSize: response.data.pageSize,
      hasMore: response.data.hasMore,
    );
  }
}
