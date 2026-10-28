
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/dashboard/domain/usecase/get_ride_history.dart';
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_event.dart';
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_state.dart';


class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetRideHistory getRideHistory;

  HistoryBloc({
    required this.getRideHistory,
  }) : super(const HistoryInitial()) {
    on<HistoryRequested>(_onHistoryRequested);
  }

  Future<void> _onHistoryRequested(
    HistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    try {
      final history = await getRideHistory(
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(HistorySuccess(history));
    } catch (e) {
      emit(HistoryFailure(e.toString()));
    }
  }
}
