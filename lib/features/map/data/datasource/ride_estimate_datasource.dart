import 'package:dio/dio.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/dio_client.dart';

import '../models/ride_estimate_request_model.dart';
import '../models/ride_estimate_responce_model.dart';

abstract interface class RideEstimateRemoteDataSource {
  Future<RideEstimateResponseModel> getRideEstimate(
    RideEstimateRequestModel request,
  );
}

class RideEstimateRemoteDataSourceImpl
    implements RideEstimateRemoteDataSource {
  final DioClient dioClient;

  RideEstimateRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<RideEstimateResponseModel> getRideEstimate(
    RideEstimateRequestModel request,
  ) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.rideEstimate,
      data: request.toJson(),
    );

    final responseJson = response.data as Map<String, dynamic>;

    if (responseJson['code'] != '0000') {
      throw DioException(
        requestOptions: response.requestOptions,
        message: responseJson['message']?.toString() ??
            'Unable to calculate ride fare',
        response: response,
      );
    }

    final data = responseJson['data'] as Map<String, dynamic>;

    return RideEstimateResponseModel.fromJson(data);
  }
}