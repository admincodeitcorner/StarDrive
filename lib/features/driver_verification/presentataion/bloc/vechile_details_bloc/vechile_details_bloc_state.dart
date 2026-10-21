part of 'vechile_details_bloc_bloc.dart';

sealed class VechileDetailsBlocState extends Equatable {
  const VechileDetailsBlocState();

  @override
  List<Object?> get props => [];
}

final class VechileDetailsBlocInitial
    extends VechileDetailsBlocState {
  const VechileDetailsBlocInitial();
}

final class VechileDetailsBlocLoading
    extends VechileDetailsBlocState {
  const VechileDetailsBlocLoading();
}

final class VechileDetailsBlocSuccess
    extends VechileDetailsBlocState {
  final VehicleDetails vehicleDetails;
  final String message;

  const VechileDetailsBlocSuccess({
    required this.vehicleDetails,
    required this.message,
  });

  @override
  List<Object?> get props => [vehicleDetails, message];
}

final class VechileDetailsBlocFailure
    extends VechileDetailsBlocState {
  final String message;

  const VechileDetailsBlocFailure(this.message);

  @override
  List<Object?> get props => [message];
}