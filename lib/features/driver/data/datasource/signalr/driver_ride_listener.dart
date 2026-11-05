import 'dart:async';

import 'package:logging/logging.dart';
import 'package:star_drive/core/signalr/signalr_service.dart';

class DriverRideListener {
  DriverRideListener({
    required this._signalRService,
  });

  // Reuses the application's shared SignalR connection instead of
  // creating a separate connection specifically for ride requests.
  final SignalRService _signalRService;

  final Logger _logger = Logger('DriverRideListener');

  // Broadcast controller allows multiple subscribers, such as BLoCs,
  // to listen to incoming ride requests simultaneously.
  final StreamController<Map<String, dynamic>> _rideController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Exposes incoming ride data as a stream without allowing external
  // classes to add or modify stream events directly.
  Stream<Map<String, dynamic>> get incomingRides =>
      _rideController.stream;

  // Prevents the same listener from registering its SignalR handler
  // multiple times when start() is called repeatedly.
  bool _isStarted = false;

  Future<void> start() async {
    // Avoids duplicate initialization and event-handler registration.
    if (_isStarted) return;

    _logger.info('Starting driver ride listener...');

    // Registers a handler for incoming ride requests through the
    // existing SignalR connection.
    await _signalRService.connect(
      handlers: {
        'NewRideRequest': (arguments) {
          // Validates the event arguments before accessing the payload.
          if (arguments == null || arguments.isEmpty) {
            _logger.warning('NewRideRequest arguments are empty');
            return;
          }

          // SignalR sends the event payload as the first argument.
          final data = arguments.first;

          if (data is Map) {
            // Converts the incoming payload into a strongly typed map
            // that can be consumed by the application data layer.
            final rideData = Map<String, dynamic>.from(data);

            _logger.info('New ride request received');

            // Publishes the received ride request to all active stream
            // subscribers, keeping SignalR handling separate from BLoC.
            _rideController.add(rideData);
          } else {
            // Prevents unexpected payload types from entering the stream.
            _logger.warning(
              'Unexpected payload type: ${data.runtimeType}',
            );
          }
        },
      },
    );

    // Marks the listener as started after SignalR connection setup
    // completes successfully.
    _isStarted = true;

    _logger.info(
      'Driver listener connected: ${_signalRService.isConnected}',
    );
  }
}