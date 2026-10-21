import 'package:dio/dio.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';

import 'package:star_drive/features/driver_verification/data/models/vechile_detail_request_model.dart';
import 'package:star_drive/features/driver_verification/data/models/vechile_detail_response_model.dart';


abstract interface class VehicleDetailsRemoteDataSource {
  Future<VehicleDetailsResponseModel> submitVehicleDetails(
    VehicleDetailsRequestModel request,
  );
}

class VehicleDetailsRemoteDataSourceImpl
    implements VehicleDetailsRemoteDataSource {
  final Dio dio;

  VehicleDetailsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<VehicleDetailsResponseModel> submitVehicleDetails(
    VehicleDetailsRequestModel request,
  ) async {
    final formData = await request.toFormData();

    final response = await dio.post(
      ApiEndpoints.vechicleDetail,
      data: formData,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
      ),
    );

    final body = response.data;

    if (body is! Map) {
      throw const FormatException(
        'Invalid vehicle details API response.',
      );
    }

    final code = body['code']?.toString();
    final message = body['message']?.toString() ??
        'Vehicle details submission failed.';

    if (code != '0000') {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: message,
        type: DioExceptionType.badResponse,
      );
    }

    final data = body['data'];

    if (data is! Map) {
      throw const FormatException(
        'Vehicle details data is missing from API response.',
      );
    }

    return VehicleDetailsResponseModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }
}