import 'package:equatable/equatable.dart';

import 'package:star_drive/features/become_driver/domain/entity/become_driver_response_entity.dart';

abstract class BecomeDriverState extends Equatable {
  const BecomeDriverState();

  @override
  List<Object?> get props => [];
}

class BecomeDriverInitial extends BecomeDriverState {
  const BecomeDriverInitial();
}

class BecomeDriverLoading extends BecomeDriverState {
  const BecomeDriverLoading();
}

class BecomeDriverSuccess extends BecomeDriverState {
  final BecomeDriverResponseEntity driver;

  const BecomeDriverSuccess(this.driver);

  @override
  List<Object?> get props => [driver];
}

class BecomeDriverFailure extends BecomeDriverState {
  final String message;

  const BecomeDriverFailure(this.message);

  @override
  List<Object?> get props => [message];
}