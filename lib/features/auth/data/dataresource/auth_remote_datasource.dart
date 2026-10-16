import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/error/exception.dart';
import 'package:star_drive/core/network/api_error_handler.dart';
import 'package:star_drive/core/network/api_response.dart';
import 'package:star_drive/features/auth/data/model/login_request_model.dart';
import 'package:star_drive/features/auth/data/model/otp_request_model.dart';
import 'package:star_drive/features/auth/data/model/otp_response_model.dart';
import 'package:star_drive/features/auth/data/model/register_request_model.dart';
import 'package:star_drive/features/auth/data/model/auth_response_model.dart';
import 'package:star_drive/features/auth/data/model/reset_password_model.dart';
import 'package:star_drive/features/auth/data/model/reset_response_model.dart';
import 'package:star_drive/features/auth/data/model/verify_request_model.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  );
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<AuthResponseModel> login(LoginRequestModel loginRequestModel);
  Future<void> verifyOtp(VerifyRequestModel verifyRequestModel);
  Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel resetPasswordrrequest,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);
  @override
  Future<ApiResponse<SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.sendOtp,
        data: request.toJson(),
      );

      final body = response.data;

      if (body == null) {
        throw const FormatException('OTP response is empty.');
      }
      final code = body['code']?.toString() ?? " ";
      final message = body['message']?.toString() ?? " ";
      if (body['code']?.toString() != '0000') {
        throw Exception(body['message']?.toString() ?? 'Unable to send OTP.');
      }

      final data = body['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid OTP response data.');
      }

      final result = SendOtpResponseModel.fromJson(data);

      if (result.devCode.isEmpty) {
        throw const FormatException('OTP code is missing from response.');
      }

      return ApiResponse<SendOtpResponseModel>(
        code: code,
        message: message,
        data: result,
      );
    } on DioException catch (e, stackTrace) {
      debugPrint('========== OTP API ERROR ==========');
      debugPrint('TYPE: ${e.type}');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('UNDERLYING ERROR: ${e.error}');
      debugPrint('REQUEST URL: ${e.requestOptions.uri}');
      debugPrint('REQUEST METHOD: ${e.requestOptions.method}');
      debugPrint('REQUEST DATA: ${e.requestOptions.data}');
      debugPrint('HTTP STATUS: ${e.response?.statusCode}');
      debugPrint('SERVER RESPONSE: ${e.response?.data}');
      debugPrint('===================================');

      debugPrintStack(stackTrace: stackTrace);

      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      final body = response.data;

      if (body == null) {
        throw const FormatException('Registration response is empty.');
      }

      final code = body['code']?.toString();
      final message = body['message']?.toString();

      if (code != '0000') {
        throw Exception(message ?? 'Registration failed. Please try again.');
      }

      final rawData = body['data'];

      if (rawData is! Map<String, dynamic>) {
        throw const FormatException(
          'Registration response data is missing or invalid.',
        );
      }

      final result = AuthResponseModel.fromJson(rawData);

      debugPrint('Registration response parsed successfully.');
      debugPrint(result.toString());

      return result;
    } on DioException catch (e, stackTrace) {
      debugPrint('========== REGISTER DIO ERROR ==========');
      debugPrint('HTTP status: ${e.response?.statusCode}');
      debugPrint(
        'API error message: ${e.response?.data is Map ? (e.response?.data as Map)['message'] : e.message}',
      );
      debugPrintStack(stackTrace: stackTrace);

      throw ApiErrorHandler.handle(e);
    } catch (e, stackTrace) {
      debugPrint('========== REGISTER ERROR ==========');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final body = response.data;

      if (body == null) {
        throw const FormatException('Login response is empty.');
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
      final result = AuthResponseModel.fromJson(rawData);

      debugPrint('LOGIN USER: ${result.name}');
      debugPrint('LOGIN TOKEN RECEIVED: ${result.token.isNotEmpty}');

      return result;
    } catch (e, stackTrace) {
      debugPrint('LOGIN PARSING ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> verifyOtp(VerifyRequestModel verifyRequestModel) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.verifyOtp,
        data: verifyRequestModel.toJson(),
      );

      final body = response.data;

      if (body == null) {
        throw const FormatException('OTP verification response is empty.');
      }

      if (body['code']?.toString() != '0000') {
        throw Exception(
          body['message']?.toString() ?? 'OTP verification failed.',
        );
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );

      final body = response.data;

      if (body == null) {
        throw Exception('Empty response received from server.');
      }

      final result = ResetPasswordResponseModel.fromJson(body);

      if (result.code != '0000') {
        throw Exception(
          result.message.isNotEmpty ? result.message : 'Password reset failed.',
        );
      }

      return result;
    } on DioException catch (e) {
      debugPrint('[ResetPassword] Dio Error Type: ${e.type}');
      debugPrint('[ResetPassword] HTTP Status: ${e.response?.statusCode}');

      final data = e.response?.data;

      if (data is Map) {
        final message = data['message']?.toString();

        if (message != null && message.isNotEmpty) {
          throw Exception(message);
        }

        final errors = data['errors'];

        if (errors is Map) {
          final messages = errors.values
              .expand((value) => value is List ? value : [value])
              .map((value) => value.toString())
              .toList();

          if (messages.isNotEmpty) {
            throw Exception(messages.join('\n'));
          }
        }
      }

      throw Exception(
        e.response == null
            ? 'Unable to connect to the server. Please check your internet connection.'
            : 'Unable to reset your password. Please try again.',
      );
    } catch (e, stackTrace) {
      debugPrint('[ResetPassword] Error: $e');
      debugPrint('[ResetPassword] Stack Trace: $stackTrace');
      rethrow;
    }
  }
}
