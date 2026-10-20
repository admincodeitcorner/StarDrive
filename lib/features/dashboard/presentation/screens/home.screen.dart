import 'package:flutter/material.dart';
import 'package:star_drive/features/map/presentation/screen/map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(title: Text('Home Screen')),
      body: Column(children: [MapScreen()]),
    );
  }
}
