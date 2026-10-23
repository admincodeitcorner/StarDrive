import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapRenderScreen extends StatelessWidget {
  const MapRenderScreen({
    super.key,
    required this.position,
    required this.onMapCreated,
    required this.onStyleLoaded,
  });

  final Position position;
  final ValueChanged<MapLibreMapController> onMapCreated;
  final VoidCallback onStyleLoaded;

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
        zoom: 11,
      ),
      styleString: 'https://tiles.openfreemap.org/styles/liberty',
      onMapCreated: onMapCreated,
      onStyleLoadedCallback: onStyleLoaded,
    );
  }
}