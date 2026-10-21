import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/error/exception.dart';
import 'package:star_drive/core/network/api_response.dart';
import 'package:star_drive/core/network/dio_client.dart';
import 'package:star_drive/features/driver_verification/data/models/driver_doccuments_response_model.dart';
import 'package:star_drive/features/driver_verification/data/models/driver_documents_request_model.dart';

abstract class DriverDocumentsRemoteDataSource {
  Future<Either<Exception, ApiResponse<DriverDocumentsResponseModel>>>
      sendDocument(DriverDocumentsRequestModel request);
}

class DriverDocumentsRemoteDataSourceImpl
    implements DriverDocumentsRemoteDataSource {
  final DioClient _client;

  const DriverDocumentsRemoteDataSourceImpl(this._client);

  @override
  Future<Either<Exception, ApiResponse<DriverDocumentsResponseModel>>>
      sendDocument(DriverDocumentsRequestModel request) async {
    final FormData formData;
    try {
      
      formData = await request.toFormData();
    } on Exception catch (e) {
      return Left(e);
    }

    
    final response = await _client.postApiResponse(
      ApiEndpoints.driverDoc,
      formData,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
        
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    return response.fold<
        Either<Exception, ApiResponse<DriverDocumentsResponseModel>>>(
      (exception) => Left(exception),
      (res) {
        final body = res.data;

        if (body is! Map<String, dynamic>) {
          return const Left(
            ParsingException(
              message: 'Document upload response is empty or invalid.',
            ),
          );
        }

        try {
          final apiResponse =
              ApiResponse<DriverDocumentsResponseModel>.fromJson(
            body,
            (data) => DriverDocumentsResponseModel.fromJson(
              data as Map<String, dynamic>,
            ),
          );

          if (apiResponse.code != '0000') {
            return Left(
              ServerException(
                message:
                    body['message']?.toString() ?? 'Document upload failed.',
                statusCode: res.statusCode,
              ),
            );
          }

          return Right(apiResponse);
        } catch (_) {
          return const Left(ParsingException());
        }
      },
    );
  }
}