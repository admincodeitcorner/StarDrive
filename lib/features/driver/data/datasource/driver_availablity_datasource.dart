import '../../../../core/constant/apis_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/driver_offline_response_model.dart';
import '../models/driver_online_response_model.dart';

abstract interface class DriverAvailabilityRemoteDataSource {
  Future<DriverOnlineResponseModel> setOnline({
    required double lat,
    required double lon,
  });

  Future<DriverOfflineResponseModel> setOffline({
    required double lat,
    required double lon,
  });
}

class DriverAvailabilityRemoteDataSourceImpl
    implements DriverAvailabilityRemoteDataSource {
  final DioClient dioClient;

  DriverAvailabilityRemoteDataSourceImpl(this.dioClient);

  @override
  Future<DriverOnlineResponseModel> setOnline({
    required double lat,
    required double lon,
  }) async {
    final result = await dioClient.patchApiResponse(
      ApiEndpoints.driverOnlineStatus,
      {'lat': lat, 'lon': lon},
    );

    final response = result.fold(
      (exception) => throw exception,
      (response) => response,
    );

    final responseData = response.data as Map<String, dynamic>;

    if (responseData['code'] != '0000') {
      throw Exception(
        responseData['message'] ?? 'Unable to go online',
      );
    }

    return DriverOnlineResponseModel.fromJson(
      responseData['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<DriverOfflineResponseModel> setOffline({
    required double lat,
    required double lon,
  }) async {
    final result = await dioClient.patchApiResponse(
      ApiEndpoints.driverOfflineStatus,
      {'lat': lat, 'lon': lon},
    );

    final response = result.fold(
      (exception) => throw exception,
      (response) => response,
    );

    final responseData = response.data as Map<String, dynamic>;

    if (responseData['code'] != '0000') {
      throw Exception(
        responseData['message'] ?? 'Unable to go offline',
      );
    }

    return DriverOfflineResponseModel.fromJson(
      responseData['data'] as Map<String, dynamic>,
    );
  }
}