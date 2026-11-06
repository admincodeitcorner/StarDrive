import 'package:dartz/dartz.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/dio_client.dart';

import '../../../../core/error/exception.dart';
import '../models/accept_offer_response.dart';


class DriverOfferResponseRemoteDataSource {
  const DriverOfferResponseRemoteDataSource({
    required this._dioClient,
  });

  final DioClient _dioClient;


  /// Accepts an incoming ride offer and returns the accepted ride details.
  Future<Either<Exception, AcceptOfferResponseModel>> acceptOffer({
    required String requestId,
    required int driverProfileId,
  }) async {
    final result = await _dioClient.postApiResponse(
      ApiEndpoints.acceptDriverOffer,
      {
        'requestId': requestId,
        'driverProfileId': driverProfileId,
      },
    );

    return result.fold(
      (exception) => Left(exception),
      (response) {
        try {
          final responseJson = _asJsonMap(response.data);

          _validateResponse(
            responseJson,
            statusCode: response.statusCode,
          );

          final responseData = _asJsonMap(responseJson['data']);

          final model = AcceptOfferResponseModel.fromJson(
            responseData,
          );

          return Right(model);
        } on ServerException catch (exception) {
          return Left(exception);
        } on FormatException catch (exception) {
          return Left(
            ParsingException(
              message: exception.message,
            ),
          );
        } on Exception catch (exception) {
          return Left(
            ParsingException(
              message: exception.toString(),
            ),
          );
        }
      },
    );
  }

  /// Declines an incoming ride offer and validates the API response.
  Future<Either<Exception, void>> declineOffer({
    required String requestId,
    required int driverProfileId,
  }) async {
    final result = await _dioClient.postApiResponse(
      ApiEndpoints.declineDriverOffer,
      {
        'requestId': requestId,
        'driverProfileId': driverProfileId,
      },
    );

    return result.fold(
      (exception) => Left(exception),
      (response) {
        try {
          final responseJson = _asJsonMap(response.data);

          _validateResponse(
            responseJson,
            statusCode: response.statusCode,
          );

          return const Right(null);
        } on ServerException catch (exception) {
          return Left(exception);
        } on FormatException catch (exception) {
          return Left(
            ParsingException(
              message: exception.message,
            ),
          );
        } on Exception catch (exception) {
          return Left(
            ParsingException(
              message: exception.toString(),
            ),
          );
        }
      },
    );
  }

  /// Converts dynamic API response data into a strongly typed JSON map.
  Map<String, dynamic> _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }

    throw const FormatException(
      'Invalid API response format.',
    );
  }

  /// Validates the backend business-level response code.
  void _validateResponse(
    Map<String, dynamic> response, {
    int? statusCode,
  }) {
    final code = response['code']?.toString();
    final message = response['message']?.toString();

    if (code != '0000') {
      throw ServerException(
        message: message?.isNotEmpty == true
            ? message!
            : 'Unable to process ride offer.',
        statusCode: statusCode,
      );
    }
  }
}