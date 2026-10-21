
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_documents_submitted_detail_response.dart';

import 'package:star_drive/features/driver_verification/domain/usecase/send_document_usecase.dart';


part 'driver_verification_event.dart';
part 'driver_verification_state.dart';

class DriverVerificationBloc
    extends Bloc<DriverVerificationEvent, DriverVerificationState> {
  final SendDocumentUseCase _sendDocument;

  DriverVerificationBloc({required this._sendDocument})
      : super(const DriverVerificationInitial()) {
    on<SendDocument>(_onSendDocument);
  }

  Future<void> _onSendDocument(
    SendDocument event,
    Emitter<DriverVerificationState> emit,
  ) async {
    // Ignore taps while an upload is already running.
    if (state is DriverVerificationLoading) return;

    emit(const DriverVerificationLoading());

    final result = await _sendDocument(event.documents);

    result.fold(
      (failure) => emit(DriverVerificationFailure(failure.message)),
      (response) => emit(DriverVerificationSuccess(response)),
    );
  }
}