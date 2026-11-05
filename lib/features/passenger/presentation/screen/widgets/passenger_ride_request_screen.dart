import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/di/injector.dart';

import '../../../../../core/signalr/passenger_ride_offer.dart';

class PassengerRideRequestScreen extends StatefulWidget {
  final int driverView;
  final int requestTime;
  const PassengerRideRequestScreen({super.key, required this.driverView, required this.requestTime});

  @override
  State<PassengerRideRequestScreen> createState() => _PassengerRideRequestScreenState();
}

class _PassengerRideRequestScreenState extends State<PassengerRideRequestScreen> {
@override
void initState() {
  super.initState();

  _startPassengerListener();
}

Future<void> _startPassengerListener() async {
  print('PASSENGER SCREEN: Starting listener');

  try {
    await sl<PassengerRideListener>().start();

    print('PASSENGER SCREEN: Listener started');
  } catch (e, stackTrace) {
    print('PASSENGER LISTENER ERROR: $e');
    print(stackTrace);
  }
}  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
          Text('driver view ${widget.driverView.toString()} '),
          Text('request time ${widget.requestTime.toString()}'),
        
        ],)
               ),
    );
  }}