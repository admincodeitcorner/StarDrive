


import 'package:star_drive/features/dashboard/domain/entities/ride_history.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistorySuccess extends HistoryState {
  final RideHistory history;

  const HistorySuccess(this.history);
}

class HistoryFailure extends HistoryState {
  final String message;

  const HistoryFailure(this.message);
}
