part of 'driver_verification_bloc.dart';

sealed class DriverVerificationEvent extends Equatable {
  const DriverVerificationEvent();

  @override
  List<Object?> get props => [];
}

/// Submits license number, expiry date and the four document images.
final class SendDocument extends DriverVerificationEvent {
  final DriverDocuments documents;

  const SendDocument(this.documents);

  @override
  List<Object?> get props => [documents];
}