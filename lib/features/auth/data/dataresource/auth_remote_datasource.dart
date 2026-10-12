
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/api_responce.dart';
import 'package:star_drive/features/auth/data/model/login_request_model.dart';
import 'package:star_drive/features/auth/data/model/register_request_model.dart';
import 'package:star_drive/features/auth/data/model/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(
    RegisterRequestModel request,
  );
  Future<AuthResponseModel> login(LoginRequestModel loginRequestModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> register(
    RegisterRequestModel request,
  ) async {
    final response = await dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE DATA: ${response.data}');

    final body = response.data;

    if (body == null) {
      throw const FormatException(
        'Registration response is empty.',
      );
    }

    // Step 1: Check API success code.
    final code = body['code']?.toString();

    if (code != '0000') {
      throw FormatException(
        'Registration failed: ${body['message'] ?? 'Unknown error'}',
      );
    }

    // Step 2: Extract the actual user object.
    final rawData = body['data'];

    if (rawData is! Map<String, dynamic>) {
      throw const FormatException(
        'Registration response data is missing or invalid.',
      );
    }

    // Step 3: Parse only the user object.
    try {
      final result = AuthResponseModel.fromJson(rawData);
      debugPrint('USER PARSED SUCCESSFULLY: ${result.name}');
      return result;
    } catch (e, stackTrace) {
      debugPrint('REGISTRATION PARSING ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

    @override
  Future<AuthResponseModel> login(
    LoginRequestModel request,
  ) async {
    final response = await dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    debugPrint('LOGIN STATUS CODE: ${response.statusCode}');
    debugPrint('LOGIN RESPONSE DATA: ${response.data}');

    final body = response.data;

    if (body == null) {
      throw const FormatException(
        'Login response is empty.',
      );
    }

    final code = body['code']?.toString();

    if (code != '0000') {
      throw FormatException(
        'Login failed: ${body['message'] ?? 'Unknown error'}',
      );
    }

    final rawData = body['data'];

    if (rawData is! Map<String, dynamic>) {
      throw const FormatException(
        'Login response data is missing or invalid.',
      );
    }

    try {
      final result = AuthResponseModel.fromJson(rawData);

      debugPrint('LOGIN USER: ${result.name}');
      debugPrint(
        'LOGIN TOKEN RECEIVED: ${result.token.isNotEmpty}',
      );

      return result;
    } catch (e, stackTrace) {
      debugPrint('LOGIN PARSING ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

}