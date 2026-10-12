import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapScreen extends StatelessWidget {
   MapScreen({super.key});
  final controller = Completer<MapLibreMapController>();

  static const _initial = CameraPosition(target: LatLng(0, 0), zoom: 2);
  static const String mapStyleUrl =
    'https://tiles.openfreemap.org/styles/liberty';

  void onMapCreated(
    MapLibreMapController mapController,
  ) {
    mapController = mapController;

    debugPrint('========== MAP CREATED ==========');

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  body: Stack(
    children: [

      // Map
     MapLibreMap(
            initialCameraPosition:
              _initial,

            styleString:
              mapStyleUrl,

            onMapCreated: onMapCreated,

            onStyleLoadedCallback:
(){}          ),


      // Search box
      Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Text(" Search Location")
      ),

      // Current location button
      Positioned(
        right: 16,
        bottom: 330,
        child:  Text('Current Location '),
      ),

      // Bottom sheet
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Text(" bOTTOM SHETT"),
      
      ),
    ],
  ),
);
  
  }
}