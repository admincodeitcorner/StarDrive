import 'dart:async';

import 'package:logging/logging.dart';

import 'package:signalr_netcore/signalr_client.dart';
import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/storage/token_storage.dart';

typedef SignalREventHandler = void Function(List<Object?>? arguments);

class SignalRService {
  SignalRService({required this._tokenStorage});

  final TokenStorage _tokenStorage;

  HubConnection? _connection;
  Future<void>? _connecting;
  final Set<String> _registeredEvents = {};
  

  final Logger logger = Logger('SignalRService');
  String get _hubUrl {
    final baseUrl = ApiEndpoints.baseUrl
        .replaceFirst(RegExp(r'/+$'), '')
        .replaceFirst(RegExp(r'/api$', caseSensitive: false), '');

    return '$baseUrl/hubs/ride';
  }

  bool get isConnected => _connection?.state == HubConnectionState.Connected;
  //get token
  Future<String> _getToken() async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw StateError('JWT token missing');
    }
    return token;
  }

  /// Subscribes [handlers] to [connection].
  ///
  /// Each event name is registered only once. If an event is already in
  /// [_registeredEvents], the new handler is skipped to avoid duplicate calls.
  void _registerHandlers(
    HubConnection connection,
    Map<String, SignalREventHandler> handlers,
  ) {
    for (final entry in handlers.entries) {
      final event = entry.key;
      final handler = entry.value;

      // Skip events that already have a handler.
      if (_registeredEvents.contains(event)) {
        logger.fine('Handler already registered, skipped: $event');
        continue;
      }

      connection.on(event, (arguments) {
        logger.info('Event received: $event');
        logger.fine('Event payload: $arguments');
        handler(arguments);
      });

      _registeredEvents.add(event);
      logger.info('Event handler registered: $event');
    }
  }

  /// Creates the connection (if needed), registers handlers and starts it.
  Future<void> _connectInternal(
    Map<String, SignalREventHandler> handlers,
  ) async {
    final connection = _connection ??= _buildConnection();

    _registerHandlers(connection, handlers);

    await connection.start();
  }

  /// Builds the hub connection with auth, reconnect policy and lifecycle logs.
  HubConnection _buildConnection() {
    final connection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: HttpConnectionOptions(
            logger: logger,
            accessTokenFactory: _getToken,
          ),
        )
        .configureLogging(logger)
        .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 20000])
        .build();

    // Registered once, .
    connection.onclose(({Exception? error}) {
      logger.warning('SignalR closed: ${error ?? 'No error'}');
    });

    return connection;
  }

  Future<void> connect({
  Map<String, SignalREventHandler> handlers = const {},
}) async {
  final activeConnection = _connection;
  final ongoingAttempt = _connecting;

  if (isConnected) {
    // Already connected: just attach the new handlers.
    _registerHandlers(activeConnection!, handlers);
  } else if (ongoingAttempt != null) {
    // Another caller is connecting: wait for it instead of starting a second one.
    await _joinOngoingAttempt(ongoingAttempt, handlers);
  } else if (activeConnection != null &&
      (activeConnection.state == HubConnectionState.Connecting ||
          activeConnection.state == HubConnectionState.Reconnecting)) {
    // Connecting/Reconnecting: calling start() again would throw, so only attach handlers.
    _registerHandlers(activeConnection, handlers);
  } else {
    // Nothing in progress: start a new attempt.
    await _startNewAttempt(handlers);
  }
}

Future<void> _joinOngoingAttempt(
  Future<void> ongoingAttempt,
  Map<String, SignalREventHandler> handlers,
) async {
  try {
    await ongoingAttempt;
  } catch (_) {
    // The shared attempt failed; fall back to starting our own below.
  }

  final readyConnection = _connection;
  if (readyConnection != null &&
      readyConnection.state == HubConnectionState.Connected) {
    // The shared attempt succeeded: attach our handlers.
    _registerHandlers(readyConnection, handlers);
  } else {
    // The shared attempt failed: try again ourselves.
    await _startNewAttempt(handlers);
  }
}

Future<void> _startNewAttempt(
    Map<String, SignalREventHandler> handlers) async {
  // Share this attempt with other callers.
  final newAttempt = _connectWithRetry(handlers);
  _connecting = newAttempt;
  try {
    await newAttempt;
  } finally {
    // Clear only if the flag still belongs to this attempt.
    if (identical(_connecting, newAttempt)) _connecting = null;
  }
}

Future<void> _connectWithRetry(
    Map<String, SignalREventHandler> handlers) async {
  const maxAttempts = 5; // Limit retries to protect battery and server.

  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      // Timeout prevents hanging forever on a dead server or bad network.
      await _connectInternal(handlers).timeout(const Duration(seconds: 15));
      return;
    } on Exception {
      // Out of attempts: let the caller know it failed.
      if (attempt == maxAttempts - 1) rethrow;

      // Exponential backoff: 2s, 4s, 8s, 16s.
      await Future.delayed(Duration(seconds: 1 << (attempt + 1)));
    }
  }
}


  // Calls [methodName] on the server hub with optional [args].
Future<Object?> invoke(String methodName, {List<Object>? args}) async {
  final connection = _connection;

  if (connection == null || !isConnected) {
    throw StateError('SignalR is not connected (state: $connection.state)');
  }

  return connection.invoke(methodName, args: args ?? const <Object>[]);
}

  // Stops the connection and resets all internal state.
 Future<void> disconnect() async {
    final connection = _connection;

    // Reset state first so a new connect() starts from a clean slate.
    _connection = null;
    _connecting = null;

    if (connection == null) return;

    // Remove handlers from the old connection.
    for (final event in _registeredEvents) {
      connection.off(event);
    }
    _registeredEvents.clear();

    await connection.stop();
  }
}
