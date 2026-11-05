
import 'package:flutter/material.dart';


import '../../../passenger/presentation/screen/passenger_screen.dart';
import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(title: Text('Welcome to StarRide')),
      body: const PassengerScreen(),
      
    );
  }
}
