import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/incoming_ride_entity.dart';
import '../../../domain/usecase/incoming_ride_usecase.dart';

part 'incoming_ride_event.dart';
part 'incoming_ride_state.dart';

class IncomingRideBloc extends Bloc<IncomingRideEvent, IncomingRideState> {
  IncomingRideBloc({required this.listenIncomingRidesUseCase})
    : super(IncomingRideInitial()) {
    on<StartIncomingRideListener>(_onStartListening);
    on<IncomingRideReceived>(_onRideReceived);
    on<RemoveIncomingRide>(_onRemoveRide);
    on<IncomingRideListenerFailed>(_onListenerFailed);
  }

  final ListenIncomingRidesUseCase listenIncomingRidesUseCase;

  // Holds the active subscription to the incoming ride stream.
  StreamSubscription<IncomingRideEntity>? _rideSubscription;

  // Maintains the current list of incoming ride requests.
  final List<IncomingRideEntity> _requests = [];
  // Each ride has its own expiry timer.
  final Map<String, Timer> _expiryTimers = {};

  /// Starts listening for incoming ride requests.
  Future<void> _onStartListening(
    StartIncomingRideListener event,
    Emitter<IncomingRideState> emit,
  ) async {
    // Prevents multiple subscriptions when the start event is triggered again.
    if (_rideSubscription != null) return;

    emit(IncomingRideLoading());

    try {
      // Subscribe to the stream provided by the domain use case.
      // Each received ride is forwarded to the BLoC event queue.
      _rideSubscription = listenIncomingRidesUseCase().listen(
        (ride) {
          if (!isClosed) {
            add(IncomingRideReceived(ride));
          }
        },
        onError: (error) {
          if (!isClosed) {
            add(IncomingRideListenerFailed(error.toString()));
          }
        },
      );

      // Listening has started; show an empty list until rides arrive.
      emit(IncomingRideLoaded(requests: List.unmodifiable(_requests)));
    } catch (error) {
      emit(IncomingRideError(message: error.toString()));
    }
  }

  /// Adds a newly received ride to the current list.
  void _onRideReceived(
    IncomingRideReceived event,
    Emitter<IncomingRideState> emit,
  ) {
    final ride = event.ride;

    // Avoid adding the same ride request more than once.
    final alreadyExists = _requests.any(
      (request) => request.requestId == ride.requestId,
    );

    if (alreadyExists) return;

    // New ride requests appear at the top of the list.
    _requests.insert(0, ride);
    _startExpiryTimer(ride);
    emit(IncomingRideLoaded(requests: List.unmodifiable(_requests)));
  }

  /// Removes a ride after it has been successfully accepted or declined.
  void _onRemoveRide(
    RemoveIncomingRide event,
    Emitter<IncomingRideState> emit,
  ) {
    _expiryTimers.remove(event.requestId)?.cancel();
    _requests.removeWhere((ride) => ride.requestId == event.requestId);

    emit(IncomingRideLoaded(requests: List.unmodifiable(_requests)));
  }

  /// Handles errors received from the incoming ride stream.
  void _onListenerFailed(
    IncomingRideListenerFailed event,
    Emitter<IncomingRideState> emit,
  ) {
    emit(IncomingRideError(message: event.message));
  }

  @override
  Future<void> close() async {
    await _rideSubscription?.cancel();

    for (final timer in _expiryTimers.values) {
      timer.cancel();
    }

    _expiryTimers.clear();

    return super.close();
  }

  void _startExpiryTimer(IncomingRideEntity ride) {
    // Cancel previous timer if it exists.
    _expiryTimers.remove(ride.requestId)?.cancel();
  if (ride.secondsRemaining <= 0) {
    add(RemoveIncomingRide(ride.requestId));
    return;
  }

    final timer = Timer(Duration(seconds: ride.secondsRemaining), () {
      if (!isClosed) {
        add(RemoveIncomingRide(ride.requestId));
      }
    });

    _expiryTimers[ride.requestId] = timer;
  }
}
