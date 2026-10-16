import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? controller;
  Circle? marker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLibreMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.7215, 73.0433),
          zoom: 12,
        ),
        styleString: 'https://tiles.openfreemap.org/styles/liberty',
        onStyleLoadedCallback: () {},
        onMapCreated: (MapLibreMapController mapController) {
          controller = mapController;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final position = await Geolocator.getCurrentPosition();
            controller?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(position.latitude, position.longitude),
              ),
            );

            if (marker != null) {
              controller?.removeCircle(marker!);
            }
            marker = await controller?.addCircle(
              CircleOptions(
                geometry: LatLng(position.latitude, position.longitude),
                circleRadius: 10,
                circleColor: "#FF0000",
              ),
            );
            setState(() {});
          } catch (e) {
            log("Error occurred while fetching current position: $e");
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
