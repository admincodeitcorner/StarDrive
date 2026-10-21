import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/api_error_handler.dart';
import 'package:star_drive/core/network/auth_inceptor.dart';
import 'package:star_drive/core/storage/token_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient(
{        required TokenStorage tokenStorage,}
  ) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Api-secret-key':
              r"EasyGo_S##ECRETt_Key_98234789234-+,8923,74892374982374-E@$y60 ",
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
        dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        baseUrl: ApiEndpoints.baseUrl,
      ),
    );

    setupApiLogging();
  }
  void setupApiLogging() {
    if (!kDebugMode) return;

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (object) => debugPrint('$object'),
      ),
    );
  }

  Future<Either<Exception, Response>> getApiResponse(String url) async {
    try {
      final response = await dio.get(url);
      return Right(response); // Success
    } on DioException catch (e) {
      return Left(e); // API/network failure
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, Response>> postApiResponse(
    String url,
    dynamic body, {
    Options? options,
  }) async {
    try {
      final response = await dio.post(url, data: body, options: options);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handle(e)); // API/network failure
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
