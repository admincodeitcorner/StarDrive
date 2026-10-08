import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../services/location_service.dart';

class MapViewModel {
  MapLibreMapController? controller;

  final LocationService locationService = LocationService();

  Position? currentPosition;

  bool styleLoaded = false;
  bool markerAdded = false;

static const String mapStyleUrl =
    'https://tiles.openfreemap.org/styles/liberty';

  // This is only the initial map position before GPS location is available.
  static const CameraPosition initialCameraPosition =
      CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 12,
  );

  // Called when the MapLibre map is created.
  void onMapCreated(
    MapLibreMapController mapController,
  ) {
    controller = mapController;

    debugPrint('========== MAP CREATED ==========');

    getUserLocation();
  }

  // Called when the MapLibre map style has finished loading.
  void onStyleLoaded() {
    debugPrint('========== MAP STYLE LOADED ==========');

    styleLoaded = true;

    showUserLocation();
  }

  // Gets the user's current GPS location.
  Future<void> getUserLocation() async {
    debugPrint('========== STARTING USER LOCATION ==========');

    final position =
        await locationService.getCurrentLocation();

    if (position == null) {
      debugPrint(
        '========== LOCATION IS NULL ==========',
      );
      return;
    }

    // Store the actual GPS position received from the device.
    currentPosition = position;

    debugPrint(
      '========== GPS LOCATION ==========\n'
      'Latitude: ${position.latitude}\n'
      'Longitude: ${position.longitude}',
    );

    // Show the user location on the map.
    showUserLocation();
  }

  // Displays the user's actual GPS location on the map
  // and moves the camera to that location.
  Future<void> showUserLocation() async {
  if (controller == null) {
    debugPrint('Map controller not ready');
    return;
  }

  if (!styleLoaded) {
    debugPrint('Map style not loaded yet');
    return;
  }

  if (currentPosition == null) {
    debugPrint('Current position not available yet');
    return;
  }

  // Get the actual GPS coordinates of the user.
  final location = LatLng(
    currentPosition!.latitude,
    currentPosition!.longitude,
  );

  // Add a blue user location marker at the exact GPS position.
  if (!markerAdded) {
    await controller!.addCircle(
      CircleOptions(
        geometry: location,
        circleRadius: 8.0,
        circleColor: '#4285F4',
        circleOpacity: 1.0,
        circleStrokeWidth: 3.0,
        circleStrokeColor: '#FFFFFF',
      ),
    );

    markerAdded = true;

    debugPrint(
      '========== USER LOCATION MARKER ADDED ==========\n'
      'Latitude: ${location.latitude}\n'
      'Longitude: ${location.longitude}',
    );
  }

  // Move the camera to the user's actual GPS location.
  await controller!.animateCamera(
    CameraUpdate.newLatLngZoom(
      location,
      12,
    ),
  );

  debugPrint(
    '========== CAMERA MOVED TO USER ==========\n'
    'Latitude: ${location.latitude}\n'
    'Longitude: ${location.longitude}',
  );
}
}