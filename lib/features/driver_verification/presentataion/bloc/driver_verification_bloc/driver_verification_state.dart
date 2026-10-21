part of 'driver_verification_bloc.dart';

sealed class DriverVerificationState extends Equatable {
  const DriverVerificationState();

  @override
  List<Object?> get props => [];
}

final class DriverVerificationInitial extends DriverVerificationState {
  const DriverVerificationInitial();
}

final class DriverVerificationLoading extends DriverVerificationState {
  const DriverVerificationLoading();
}

final class DriverVerificationSuccess extends DriverVerificationState {
  final DriverDocumentsSubmittedDetailResponse  driverDocumentsSubmittedDetail;

  const DriverVerificationSuccess(this.driverDocumentsSubmittedDetail);

  @override
  List<Object?> get props => [driverDocumentsSubmittedDetail];
}

final class DriverVerificationFailure extends DriverVerificationState {
  final String message;

  const DriverVerificationFailure(this.message);

  @override
  List<Object?> get props => [message];
}