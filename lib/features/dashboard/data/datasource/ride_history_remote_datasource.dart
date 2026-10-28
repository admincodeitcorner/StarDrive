
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/api_error_handler.dart';
import 'package:star_drive/features/dashboard/data/model/ride_history_model.dart';

import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_state.dart';

abstract class HistoryRemoteDataSource {
  Future<RideHistoryResponse> getRideHistory({
    int page = 1,
    int pageSize = 20,
  });
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final Dio dio;

  HistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<RideHistoryResponse> getRideHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.rideHistory,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );

      final body = response.data;

      if (body == null) {
        throw const FormatException(
          'Ride history response is empty.',
        );
      }

      final apiResponse = RideHistoryResponse.fromJson(body);

      if (apiResponse.code != '0000') {
        throw FormatException(apiResponse.message);
      }

      return apiResponse;
    } on DioException catch (e) {
      debugPrint('[RideHistory] API error: $e');
      throw ApiErrorHandler.handle(e);
    }
  }
}
