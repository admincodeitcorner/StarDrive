 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../map/presentation/bloc/map_bloc/map_bloc.dart';

void showPermanentDenialDialog(BuildContext context, [bool dialogShowing = false, bool settingsOpened = false]) {
    if (dialogShowing) return;
    dialogShowing = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location Permission Blocked'),
        content: const Text(
          'Please enable location permission in app settings '
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

              context.read<MapBloc>().add(const OpenAppSettingsEvent());
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    ).whenComplete(() {
      dialogShowing = false;
    });
  }
