import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/map_usecase.dart';
import 'map_events.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvents, MapState> {
  final MapUseCase mapUseCase;

  MapBloc(this.mapUseCase) : super(MapInitial()) {
    on<GetCurrentLocationEvent>((event, emit) async {
      emit(MapLocationLoading());

      try {
        final position = await mapUseCase();
        emit(MapLocationSuccess(position: position));
      } catch (e) {
        emit(MapLocationFailure(message: e.toString()));
      }
    });
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'map_events.dart';
// import 'map_state.dart';

// class MapBloc extends Bloc<MapEvents, MapState> {
  
//   MapBloc() : super(MapInitial()) {
//     on<GetCurrentLocationEvent>((event, emit) async {
//       // ignore: unnecessary_type_check
//       if (event is GetCurrentLocationEvent) {
//         emit(MapLocationLoading());
//         final position = await event.getCurrentLocation();
//         emit(MapLocationSuccess(position: position));
//       }
//     });
//   }
// }
