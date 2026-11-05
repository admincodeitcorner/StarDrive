import 'package:equatable/equatable.dart';

import '../../../domain/entities/ride_estimate_response_entity.dart';

abstract class RideEstimateState extends Equatable {
  const RideEstimateState();

  @override
  List<Object?> get props => [];
}

class RideEstimateInitial extends RideEstimateState {
  const RideEstimateInitial();
}

class RideEstimateLoading extends RideEstimateState {
  const RideEstimateLoading();
}

class RideEstimateSuccess extends RideEstimateState {
  final RideEstimateEntity estimate;

  const RideEstimateSuccess(this.estimate);

  @override
  List<Object?> get props => [estimate];
}

class RideEstimateFailure extends RideEstimateState {
  final String message;

  const RideEstimateFailure(this.message);

  @override
  List<Object?> get props => [message];
}