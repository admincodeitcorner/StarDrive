import 'package:logging/logging.dart';
import 'package:star_drive/core/network/dio_client.dart';
import 'package:star_drive/core/signalr/signalr_service.dart';

import '../constant/apis_endpoints.dart';

class DriverLocationSender {
  DriverLocationSender({required this.signalRService, required this.dioClient});

  final SignalRService signalRService;
  final DioClient dioClient;
  final Logger logger = Logger('DriverLocationSender');
  Future<void> sendLocation({required double lat, required double lon}) async {
    
    //send location via SignalR if connected
    if (signalRService.isConnected) {
      try {
        await _invokeLocation(lat, lon);

        return;
      } catch (error, stackTrace) {
        logger.warning(
          'SignalR location update failed. Using REST fallback.',
          error,
          stackTrace,
        );
      }
    } //Reconnected if SignalR is disconnected
    else{
      await signalRService.connect();

      if (signalRService.isConnected) {
        await _invokeLocation(lat, lon);
        return;
      }
    }

    //REST fallback if SignalR fails.
    final result = await dioClient.postApiResponse(
      ApiEndpoints.driverLocationUpdate,
      {'lat': lat, 'lon': lon},
    );

    result.fold((error) => throw error, (response) {
      logger.fine('REST location update successful: ${response.data}');
    });
  }

  Future<void> _invokeLocation(double lat, double lon) async {
    final response = await signalRService.invoke(
      'UpdateLocation',
      args: <Object>[
        <String, double>{'lat': lat, 'lon': lon},
      ],
    );
    logger.info('SignalR Location Response: $response');
  }
}
