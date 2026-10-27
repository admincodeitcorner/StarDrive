
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final String baseUrl;

  AuthInterceptor({
    required this.tokenStorage,
    required this.baseUrl,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] != false;

    final sameOrigin =
        options.uri.origin == Uri.parse(baseUrl).origin;

    if (kDebugMode) {
      debugPrint('========== AUTH DEBUG ==========');
      debugPrint('Path: ${options.uri.path}');
      debugPrint('Requires auth: $requiresAuth');
      debugPrint('Same origin: $sameOrigin');
    }

    if (!requiresAuth || !sameOrigin) {
      options.headers.remove('Authorization');

      if (kDebugMode) {
        debugPrint('Authorization skipped');
        debugPrint('================================');
      }

      handler.next(options);
      return;
    }

    try {
      final token = await tokenStorage.getToken();
      final hasToken = token != null && token.trim().isNotEmpty;

      if (hasToken) {
        options.headers['Authorization'] = 'Bearer ${token!.trim()}';
      } else {
        options.headers.remove('Authorization');
      }

      if (kDebugMode) {
        debugPrint('Stored token available: $hasToken');
        debugPrint(
          'Authorization attached: '
          '${options.headers.containsKey('Authorization')}',
        );
        debugPrint('================================');
      }

      handler.next(options);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Token storage read failed: $error');
      }

      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          message: 'Unable to read authentication token.',
        ),
      );
    }
  }
}
