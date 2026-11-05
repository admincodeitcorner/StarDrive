import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exception.dart';

import '../../../../core/constant/apis_endpoints.dart' show ApiEndpoints;
import '../../../../core/network/api_error_handler.dart';
import '../models/ride_request_response_model.dart';

abstract interface class RideRequestRemoteDataSource {
  Future<Either<Exception, RideRequestResponseModel>> requestRide(

    String estimateId,
    int offerFare,
  );
}

class RideRequestRemoteDataSourceImpl implements RideRequestRemoteDataSource {
  final DioClient apiClient;

  const RideRequestRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<Exception, RideRequestResponseModel>> requestRide(
    String estimateId,
    int offerFare,
  ) async {
    try {
      final response = await apiClient.postApiResponse(
        ApiEndpoints.passengerRideRequest,
        {
          'estimateId': estimateId,
          'offeredFare': offerFare,
        },
      );

      final result = response.fold<Either<Exception, RideRequestResponseModel>>(
        (exception) => Left(exception),
        (response) {
          try {
            final responseData = response.data;

            if (responseData is! Map<String, dynamic>) {
              return const Left(ParsingException());
            }

            if (responseData['code'] != '0000') {
              return Left(
                ServerException(
                  message:
                      responseData['message']?.toString() ??
                      'Ride request failed',
                ),
              );
            }

            return Right(RideRequestResponseModel.fromJson(responseData));
          } catch (e) {
            return const Left(ParsingException());
          }
        },
      );

      return result;
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handle(e));
    } catch (e) {
      return const Left(ServerException(message: 'Something went wrong'));
    }
  }
}
