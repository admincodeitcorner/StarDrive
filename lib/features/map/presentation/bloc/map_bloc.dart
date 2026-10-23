import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:star_drive/features/map/data/datasource/location_data_source.dart';
import 'package:star_drive/features/map/domain/repository/map_reposity.dart';


part 'map_events.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationRepository repository;

  MapBloc(this.repository) : super(const MapInitial()) {
    on<InitializeMapEvent>((event, emit) async {
      await _loadLocation(emit);
    });

    on<RetryLocationEvent>((event, emit) async {
      await _loadLocation(emit);
    });

    on<RequestLocationPermissionEvent>((event, emit) async {
      try {
        final permission = await repository.requestPermission();

        if (permission == LocationPermission.deniedForever) {
          emit(const MapPermissionPermanentlyDenied());
          return;
        }

        if (permission == LocationPermission.denied) {
          emit(const MapPermissionRequired());
          return;
        }

        await _loadLocation(emit);
      } catch (e) {
        emit(MapLocationFailure('Permission request failed: $e'));
      }
    });

    on<OpenAppSettingsEvent>((event, emit) async {
      try {
        await repository.openAppSettings();
      } catch (e) {
        emit(MapLocationFailure('Could not open app settings: $e'));
      }
    });

    on<OpenLocationSettingsEvent>((event, emit) async {
      try {
        await repository.openLocationSettings();
      } catch (e) {
        emit(MapLocationFailure('Could not open location settings: $e'));
      }
    });
  }

  Future<void> _loadLocation(Emitter<MapState> emit) async {
    emit(const MapLocationLoading());

    try {
      final serviceEnabled =
          await repository.isLocationServiceEnabled();

      if (!serviceEnabled) {
        emit(const MapLocationServiceDisabled());
        return;
      }

      var permission = await repository.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        emit(const MapPermissionPermanentlyDenied());
        return;
      }

      if (permission == LocationPermission.denied) {
        emit(const MapPermissionRequired());
        return;
      }

      final position = await repository.getCurrentLocation();
      emit(MapLocationSuccess(position));
    } on LocationServiceDisabledException {
      emit(const MapLocationServiceDisabled());
    } on LocationPermissionDeniedException {
      emit(const MapPermissionRequired());
    } on LocationPermissionPermanentlyDeniedException {
      emit(const MapPermissionPermanentlyDenied());
    } catch (e) {
      emit(MapLocationFailure(
        'Current location nahi mil saki. Dobara try karein.',
      ));
    }
  }
}