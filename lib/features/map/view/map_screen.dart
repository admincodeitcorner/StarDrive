import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:star_drive/features/map/view/view_model/view_model.dart';
import 'package:star_drive/features/map/view/widgets/current_location.dart';
import 'package:star_drive/features/map/view/widgets/ride_buttom_sheet.dart';
import 'package:star_drive/features/map/view/widgets/search_location.dart';

class MapScreen extends StatelessWidget {
   MapScreen({super.key});
  final _controllerCompleter = Completer<MapLibreMapController>();
  bool _styleLoaded = false;
 final MapViewModel viewModel = MapViewModel();
  static const _initial = CameraPosition(target: LatLng(0, 0), zoom: 2);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
  body: Stack(
    children: [

      // Map
     MapLibreMap(
            initialCameraPosition:
                MapViewModel.initialCameraPosition,

            styleString:
                MapViewModel.mapStyleUrl,

            onMapCreated: viewModel.onMapCreated,

            onStyleLoadedCallback:
                viewModel.onStyleLoaded,
          ),


      // Search box
      Positioned(
        top: 50,
        left: 16,
        right: 16,
        // child: Text(" Search Location")
        child: SearchLocation(),
      ),

      // Current location button
      Positioned(
        right: 16,
        bottom: 330,
        // child:  Text('Current Location '),
        child: CurrentLocationButton(onPressed: viewModel.getUserLocation,),
      ),

      // Bottom sheet
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
      
        child: RideBottomSheet(),
      ),
    ],
  ),
);
  
  }
}