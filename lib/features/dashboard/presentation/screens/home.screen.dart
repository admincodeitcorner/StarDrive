import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:star_drive/features/map/presentation/screen/map_screen.dart';
import 'package:star_drive/features/auth/domain/entities/auth_user.dart';

import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, this.userName = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapLibreMapController? controller;
  Circle? marker;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(userName: widget.userName),
      appBar: AppBar(title: Text('Welcome to StarRide')),
     body: const MapScreen(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     try {
      //       final position = await Geolocator.getCurrentPosition();
      //       controller?.animateCamera(
      //         CameraUpdate.newLatLng(
      //           LatLng(position.latitude, position.longitude),
      //         ),
      //       );

      //       if (marker != null) {
      //         controller?.removeCircle(marker!);
      //       }
      //       marker = await controller?.addCircle(
      //         CircleOptions(
      //           geometry: LatLng(position.latitude, position.longitude),
      //           circleRadius: 10,
      //           circleColor: "#FF0000",
      //         ),
      //       );
      //       setState(() {});
      //     } catch (e) {
      //       log("Error occurred while fetching current position: $e");
      //     }
      //   },
      //   child: const Icon(Icons.my_location),
      // ),
    );
  }
}
