import 'package:equatable/equatable.dart';

import 'package:star_drive/features/become_driver/domain/entity/become_driver_request_entity.dart';

abstract class BecomeDriverEvent extends Equatable {
  const BecomeDriverEvent();

  @override
  List<Object?> get props => [];
}

class SubmitBecomeDriver extends BecomeDriverEvent {
  final BecomeDriverRequestEntity request;

  const SubmitBecomeDriver(this.request);

  @override
  List<Object?> get props => [request];
}