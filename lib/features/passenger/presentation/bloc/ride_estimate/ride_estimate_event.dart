import 'package:equatable/equatable.dart';

import '../../../domain/entities/ride_estimate_request_entity.dart';

abstract class RideEstimateEvent extends Equatable {
  const RideEstimateEvent();

  @override
  List<Object?> get props => [];
}

class RideEstimateRequested extends RideEstimateEvent {
  final RideEstimateRequestEntity request;

  const RideEstimateRequested(this.request);

  @override
  List<Object?> get props => [request];
}
