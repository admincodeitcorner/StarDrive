 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../passenger/presentation/bloc/map_bloc/map_bloc.dart';

void showLocationServiceDialog(BuildContext context, [bool dialogShowing = false, bool settingsOpened = false]) {
    if (dialogShowing) return;
    dialogShowing = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location Service Disabled'),
        content: const Text(
          'Please turn on your device location service '
          'to go online.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              context.read<MapBloc>().add(const RetryLocationEvent());
            },
            child: const Text('Retry'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              settingsOpened = true;

              context.read<MapBloc>().add(const OpenLocationSettingsEvent());
            },
            child: const Text('Enable Location'),
          ),
        ],
      ),
    ).whenComplete(() {
      dialogShowing = false;
    });
  }
  // void _showLocationServiceDialog(BuildContext context) {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => AlertDialog(
  //       // Permanently denied
  //       title: const Text('Location Permission Denied'),
  //       content: const Text(
  //         'Location permission has been permanently denied. '
  //         'Please enable it in your app settings to continue.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);
  //             context.read<MapBloc>().add(const RetryLocationEvent());
  //           },
  //           child: const Text('Retry'),
  //         ),
  //         FilledButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);
  //             _settingsOpened = true;
  //             context.read<MapBloc>().add(const OpenLocationSettingsEvent());
  //           },
  //           child: const Text('Enable Location'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
