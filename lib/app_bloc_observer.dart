import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    debugPrint(
      '🟦 [BLoC EVENT] ${bloc.runtimeType} → ${event.runtimeType}',
    );
  }

  @override
  void onTransition(
    Bloc bloc,
    Transition transition,
  ) {
    super.onTransition(bloc, transition);

    debugPrint(
      ' [BLoC TRANSITION] ${bloc.runtimeType}\n'
      '   Event: ${transition.event.runtimeType}\n'
      '   Previous: ${transition.currentState.runtimeType}\n'
      '   Next: ${transition.nextState.runtimeType}',
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    debugPrint(
      ' [BLoC CHANGE] ${bloc.runtimeType}\n'
      '   Previous: ${change.currentState.runtimeType}\n'
      '   Next: ${change.nextState.runtimeType}',
    );
  }

  @override
  void onError(
    BlocBase bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(' [BLoC ERROR] ${bloc.runtimeType}');
    debugPrint('Error: $error');
    debugPrintStack(stackTrace: stackTrace);

    super.onError(bloc, error, stackTrace);
  }
}