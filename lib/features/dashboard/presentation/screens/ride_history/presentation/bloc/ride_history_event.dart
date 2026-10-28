
abstract class HistoryEvent {
  const HistoryEvent();
}

class HistoryRequested extends HistoryEvent {
  final int page;
  final int pageSize;

  const HistoryRequested({
    this.page = 1,
    this.pageSize = 20,
  });
}
