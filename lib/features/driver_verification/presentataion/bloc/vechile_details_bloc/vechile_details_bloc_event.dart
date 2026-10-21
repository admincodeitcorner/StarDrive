part of 'vechile_details_bloc_bloc.dart';

sealed class VechileDetailsBlocEvent extends Equatable {
  const VechileDetailsBlocEvent();

  @override
  List<Object?> get props => [];
}

final class SubmitVechileDetails
    extends VechileDetailsBlocEvent {
  final VehicleDetailsSubmission submission;

  const SubmitVechileDetails(this.submission);

  @override
  List<Object?> get props => [submission];
}