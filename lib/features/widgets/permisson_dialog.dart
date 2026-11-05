
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../passenger/presentation/bloc/map_bloc/map_bloc.dart';
void showPermissionDialog(BuildContext context,[bool dialogShowing =false]) {
    if (dialogShowing) return;
    dialogShowing = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'StarDrive needs your current location to let you '
          'go online and receive ride requests.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              context.read<MapBloc>().add(
                const RequestLocationPermissionEvent(),
              );
            },
            child: const Text('Allow Location'),
          ),
        ],
      ),
    ).whenComplete(() {
      dialogShowing = false;
    });
  }
  
  // void _showPermissionDialog(BuildContext context) {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => AlertDialog(
  //       // Permission required
  //       title: const Text('Location Permission Required'),
  //       content: const Text(
  //         'StarDrive needs access to your current location '
  //         'to display the map at your location.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);
  //             context.read<MapBloc>().add(
  //               const RequestLocationPermissionEvent(),
  //             );
  //           },
  //           child: const Text('Allow location'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

