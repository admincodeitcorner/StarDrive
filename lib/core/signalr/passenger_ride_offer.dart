import 'package:logging/logging.dart';
import 'package:star_drive/core/signalr/signalr_service.dart';

class PassengerRideListener {
  PassengerRideListener({required this._signalRService});

  final SignalRService _signalRService;

  final Logger _logger = Logger('Passenger listen  to Driver offer');

  Future<void> start() async {
    print('PASSENGER LISTENER: START CALLED');

    await _signalRService.connect(
      handlers: {
        'NewOffer': (arguments) {
          _logger.info('========== NEW OFFER RECEIVED ==========');

          if (arguments == null || arguments.isEmpty) {
            _logger.warning('NewOffer arguments are empty');
            return;
          }

          final data = arguments.first;

          _logger.info('NewOffer Payload: $data');

          if (data is Map) {
            _logger.info('Driver: ${data['driverName']}');
            _logger.info('Fare: ${data['fare']}');
            _logger.info('Vehicle: ${data['vehicleModel']}');
            _logger.info('Request ID: ${data['requestId']}');
          }

          _logger.info('========================================');
        },
      },
    );
  }
}
