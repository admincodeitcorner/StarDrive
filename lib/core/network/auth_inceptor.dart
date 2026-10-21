import 'package:dio/dio.dart';
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

    if (!requiresAuth || !sameOrigin) {
      options.headers.remove('Authorization');
      handler.next(options);
      return;
    }

    try {
      final token = await tokenStorage.getToken();

      if (token != null && token.trim().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (error) {
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