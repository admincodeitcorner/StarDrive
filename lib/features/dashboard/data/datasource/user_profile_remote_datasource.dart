import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/api_error_handler.dart';
import 'package:star_drive/features/dashboard/data/model/number_update_model.dart';
import 'package:star_drive/features/dashboard/data/model/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();

  Future<void> updatePhoneNumber(UpdatePhoneNumberModel model);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;

  UserProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> updatePhoneNumber(UpdatePhoneNumberModel model) async {
    try {
      final formData = FormData.fromMap(model.toJson());

      final response = await dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateProfile,
        data: formData,
      );

      final responseData = response.data;

      if (responseData == null) {
        throw const FormatException('Update profile response is empty.');
      }

      if (responseData['code']?.toString() != '0000') {
        throw FormatException(
          responseData['message']?.toString() ??
              'Failed to update phone number.',
        );
      }
    } on DioException catch (error) {
      debugPrint('[UpdatePhoneNumber] Request failed: ${error.message}');
      throw ApiErrorHandler.handle(error);
    }
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.userProfile,
      );
      final responseData = response.data;

      if (responseData == null) {
        throw const FormatException('Profile response is empty.');
      }

      if (responseData['code']?.toString() != '0000') {
        throw FormatException(
          responseData['message']?.toString() ?? 'Failed to fetch profile.',
        );
      }

      final rawData = responseData['data'];
      if (rawData is! Map) {
        throw const FormatException(
          'Profile data is missing or has an invalid format.',
        );
      }

      return UserProfileModel.fromJson(Map<String, dynamic>.from(rawData));
    } on DioException catch (error) {
      debugPrint('[UserProfile] Request failed: ${error.message}');
      throw ApiErrorHandler.handle(error);
    }
  }
}
