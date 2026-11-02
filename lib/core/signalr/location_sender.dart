import 'package:star_drive/core/network/dio_client.dart';
import 'package:star_drive/core/signalr/signalr_service.dart';

import '../constant/apis_endpoints.dart';


class DriverLocationSender {
  DriverLocationSender({
    required SignalRService signalRService,
    required DioClient dioClient,
  })  : _signalRService = signalRService,
        _dioClient = dioClient;

  final SignalRService _signalRService;
  final DioClient _dioClient;

  Future<void> sendLocation({
    required double lat,
    required double lon,
  }) async {
    // Try SignalR first.
    if (_signalRService.isConnected) {
      try {
        await _signalRService.invoke(
          'UpdateLocation',
          args: <Object>[
            <String, double>{
              'lat': lat,
              'lon': lon,
            },
          ],
        );

        return;
      } catch (_) {
        // SignalR failed. Try the REST fallback below.
      }
    }

    // Fallback to the existing REST API.
    final result = await _dioClient.postApiResponse(
      ApiEndpoints.driverLocationUpdate,
      {
        'lat': lat,
        'lon': lon,
      },
    );

    result.fold(
      (error) => throw error,
      (response) {
        // Dio throws for unsuccessful HTTP status codes
        // under its default validateStatus configuration.
      },
    );
  }
}