import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/accept_offer_entity.dart' show AcceptOfferResponseEntity;
import '../../../domain/usecase/accept_offer_usecase.dart' show AcceptOfferUseCase;
import '../../../domain/usecase/decline_offer_usecase.dart';


part 'driver_offer_response_event.dart';
part 'driver_offer_response_state.dart';

class DriverOfferResponseBloc
    extends Bloc<DriverOfferResponseEvent, DriverOfferResponseState> {
  DriverOfferResponseBloc({
    required this._acceptOfferUseCase,
    required this._declineOfferUseCase,
  })  : super(DriverOfferResponseInitial()) {
    on<AcceptOfferRequested>(_onAcceptOfferRequested);
    on<DeclineOfferRequested>(_onDeclineOfferRequested);
  }

  final AcceptOfferUseCase _acceptOfferUseCase;
  final DeclineOfferUseCase _declineOfferUseCase;

  /// Processes an accept request and emits the corresponding result state.
  Future<void> _onAcceptOfferRequested(
    AcceptOfferRequested event,
    Emitter<DriverOfferResponseState> emit,
  ) async {
    if (state is DriverOfferResponseLoading) return;

    emit(
      const DriverOfferResponseLoading(
        action: DriverOfferResponseAction.accept,
      ),
    );

    try {
      final result = await _acceptOfferUseCase(
        requestId: event.requestId,
        driverProfileId: event.driverProfileId,
      );

      result.fold(
        (exception) {
          emit(
            DriverOfferResponseFailure(
              message: _getErrorMessage(exception),
              action: DriverOfferResponseAction.accept,
            ),
          );
        },
        (response) {
          emit(
            DriverOfferAccepted(
              response: response,
            ),
          );
        },
      );
    } catch (error) {
      emit(
        DriverOfferResponseFailure(
          message: _getErrorMessage(error),
          action: DriverOfferResponseAction.accept,
        ),
      );
    }
  }

  /// Processes a decline request and emits the corresponding result state.
  Future<void> _onDeclineOfferRequested(
    DeclineOfferRequested event,
    Emitter<DriverOfferResponseState> emit,
  ) async {
    if (state is DriverOfferResponseLoading) return;

    emit(
      const DriverOfferResponseLoading(
        action: DriverOfferResponseAction.decline,
      ),
    );

    try {
      final result = await _declineOfferUseCase(
        requestId: event.requestId,
        driverProfileId: event.driverProfileId,
      );

      result.fold(
        (exception) {
          emit(
            DriverOfferResponseFailure(
              message: _getErrorMessage(exception),
              action: DriverOfferResponseAction.decline,
            ),
          );
        },
        (_) {
          emit(const DriverOfferDeclined());
        },
      );
    } catch (error) {
      emit(
        DriverOfferResponseFailure(
          message: _getErrorMessage(error),
          action: DriverOfferResponseAction.decline,
        ),
      );
    }
  }

  /// Converts technical exceptions into readable messages for the UI.
  String _getErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}