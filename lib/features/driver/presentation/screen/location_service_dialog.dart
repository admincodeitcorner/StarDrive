 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../passenger/map_import.dart';



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
