import 'package:dio/dio.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';


class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers:  {
              'Api-secret-key' :r"EasyGo_S##ECRETt_Key_98234789234-+,8923,74892374982374-E@$y60 ",
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );
}