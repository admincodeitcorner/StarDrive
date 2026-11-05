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
  void _registerHandlers(
    HubConnection connection,
    Map<String, SignalREventHandler> handlers,
  ) {
    for (final entry in handlers.entries) {
      if (_registeredEvents.contains(entry.key)) continue;

      connection.on(entry.key, (arguments) {
        logger.info('Event received: ${entry.key}');
        logger.fine('Event payload: $arguments');

        entry.value(arguments);
      });

      _registeredEvents.add(entry.key);

      logger.info('Event handler registered: ${entry.key}');
    }
  }

  Future<void> connect({
    Map<String, SignalREventHandler> handlers = const {},
  }) async {
    if (isConnected) {
      _registerHandlers(_connection!, handlers);
      return;
    }

    final currentAttempt = _connecting;

    if (currentAttempt != null) {
      await currentAttempt;
      final connection = _connection;
      if (connection != null) {
        _registerHandlers(connection, handlers);
      }

      return;
    }

    final attempt = _connectInternal(handlers);
    _connecting = attempt;

    try {
      await attempt;
    } finally {
      if (identical(_connecting, attempt)) {
        _connecting = null;
      }
    }
  }

  Future<void> _connectInternal(
    Map<String, SignalREventHandler> handlers,
  ) async {
    final connection = _connection ??= HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: HttpConnectionOptions(
            logger: logger,

            accessTokenFactory: () async {
              final token = await _tokenStorage.getToken();

              if (token == null || token.isEmpty) {
                throw StateError('JWT token missing');
              }

              return token;
            },
          ),
        )
        .configureLogging(logger)
        .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 20000])
        .build();
    _registerHandlers(connection, handlers);

    for (final entry in handlers.entries) {
      connection.on(entry.key, entry.value);
    }

    connection.onclose(({Exception? error}) {
      logger.warning(
        'SignalR connection closed: ${error?.toString() ?? 'No error'}',
      );
    });
    await connection.start();
  }

  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    final connection = _connection;

    if (connection == null || !isConnected) {
      throw StateError('SignalR connection is not connected');
    }

    return connection.invoke(methodName, args: args ?? <Object>[]);
  }

  Future<void> disconnect() async {
    final connection = _connection;
    _connection = null;
    _registeredEvents.clear();

    if (connection != null) {
      await connection.stop();
    }
  }
}
