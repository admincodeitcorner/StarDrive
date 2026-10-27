import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/api_response.dart';
import 'package:star_drive/core/network/dio_client.dart';
import 'package:star_drive/features/become_driver/data/models/become_driver_request_model.dart';
import 'package:star_drive/features/become_driver/data/models/become_driver_response_model.dart';

abstract interface class BecomeDriverRemoteDataSource {
  Future<Either<Exception, ApiResponse<BecomeDriverResponseModel>>>
      becomeDriver(
    BecomeDriverRequestModel request,
  );

}
class BecomeDriverRemoteDataSourceImpl
    implements BecomeDriverRemoteDataSource {
  final DioClient dioClient;

  BecomeDriverRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Exception, ApiResponse<BecomeDriverResponseModel>>>
      becomeDriver(
    BecomeDriverRequestModel request,
  ) async {
    final result = await dioClient.postApiResponse(
      ApiEndpoints.becomeDriver,
      request.toJson(),
    );

    return result.fold(
      (exception) => Left(exception),
      (response) {
        try {
            final json = response.data as Map<String, dynamic>;

          final apiResponse =
              ApiResponse<BecomeDriverResponseModel>.fromJson(
            response.data as Map<String, dynamic>,
            (data) => BecomeDriverResponseModel.fromJson(
              data as Map<String, dynamic>,
             json['message'] as String? ?? '',
 
            ),
          );

          return Right(apiResponse);
        } catch (e) {
          return Left(
            Exception('Failed to parse become-driver response: $e'),
          );
        }
      },
    );
  }
}