import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/map/presentation/bloc/map_bloc.dart';
import 'package:star_drive/features/map/presentation/bloc/map_events.dart';
import 'package:star_drive/features/map/presentation/bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MapBloc>(),
      child: const _MapScreenContent(),
    );
  }
}

class _MapScreenContent extends StatefulWidget {
  const _MapScreenContent();

  @override
  State<_MapScreenContent> createState() =>
      _MapScreenContentState();
}

class _MapScreenContentState extends State<_MapScreenContent> {
  MapLibreMapController? _mapController;
  bool _styleLoaded = false;
  bool _locationRequested = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) async {
        if (state is MapLocationSuccess &&
            _mapController != null &&
            _styleLoaded) {
          final position = state.position;

          final currentLocation = LatLng(
            position.latitude,
            position.longitude,
          );

          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              currentLocation,
              16,
            ),
          );

          await _mapController!.addCircle(
            CircleOptions(
              geometry: currentLocation,
              circleRadius: 8,
              circleColor: '#1565C0',
              circleStrokeWidth: 2,
              circleStrokeColor: '#FFFFFF',
            ),
          );
        }

        if (state is MapLocationFailure && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            MapLibreMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.7215, 73.0433),
                zoom: 12,
              ),
              styleString:
                  'https://tiles.openfreemap.org/styles/liberty',
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onStyleLoadedCallback: () {
                _styleLoaded = true;

                if (!_locationRequested) {
                  _locationRequested = true;

                  context.read<MapBloc>().add(
                    GetCurrentLocationEvent(),
                  );
                }
              },
            ),

            if (state is MapLocationLoading)
              const Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}