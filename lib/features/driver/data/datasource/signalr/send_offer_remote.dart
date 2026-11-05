import 'package:logging/logging.dart';
import 'package:star_drive/core/signalr/signalr_service.dart';

abstract class SendOfferSignalRDataSource {
  Future<Object?> sendOffer({
    required String rideId,
    required int offeredFare,
  });
}

class SendOfferSignalRDataSourceImpl implements SendOfferSignalRDataSource {
  SendOfferSignalRDataSourceImpl({required this.signalRService});

  final SignalRService signalRService;

  final Logger _logger = Logger('SendOfferSignalRDataSource');

  @override
  Future<Object?> sendOffer({
    required String rideId,
    required int offeredFare,
  }) async {
    try {
      // STEP 1: Check SignalR connection.
      if (!signalRService.isConnected) {
        _logger.warning('SignalR disconnected. Connecting...');

        await signalRService.connect();
      }

      // STEP 2: Verify connection.
      if (!signalRService.isConnected) {
        throw StateError('SignalR connection failed');
      }

      // STEP 3: Prepare payload.
      final payload = {'requestId': rideId, 'fare': offeredFare};
      // STEP 4: Print outgoing data.
      _logger.info('========== SEND OFFER START ==========');

      _logger.info('SignalR Connection: ${signalRService.isConnected}');
      _logger.info('SignalR Method: SendOffer');
      _logger.info('Ride ID: $rideId');
      _logger.info('Offered Fare: $offeredFare');
      _logger.info('Outgoing Payload: $payload');

      // STEP 5: Invoke backend method.
      final response = await signalRService.invoke(
        'SendOffer',
        args: [payload],
      );

      // STEP 6: Print backend response.
      _logger.info('========== SEND OFFER RESPONSE ==========');
      _logger.info('Response Type: ${response.runtimeType}');
      _logger.info('Backend Raw Response: $response');

      // STEP 7: Check backend application error.
      if (response is Map && response['code']?.toString() == '1001') {
        final message =
            response['message']?.toString() ?? 'Offer request failed';

        _logger.warning('BACKEND REJECTED OFFER: $message');

        throw StateError(message);
      }

      _logger.info('SignalR invocation completed.');
      _logger.info('========================================');

      return response;
    } catch (e, stackTrace) {
      _logger.severe('SEND OFFER FAILED: $e', e, stackTrace);

      rethrow;
    }
  }
}
