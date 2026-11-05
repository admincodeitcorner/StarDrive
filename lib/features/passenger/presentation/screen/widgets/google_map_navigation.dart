import 'package:flutter/material.dart';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapNavigation extends StatelessWidget {
  const GoogleMapNavigation({
    super.key,
    required this.selectedDestination,
  });

  final LatLng selectedDestination;

  Future<void> _openGoogleMapsNavigation(
    BuildContext context,
  ) async {
    final navigationUrl = Uri.https(
      'www.google.com',
      '/maps/dir/',
      {
        'api': '1',
        'destination':
            '${selectedDestination.latitude},'
            '${selectedDestination.longitude}',
        'travelmode': 'driving',
        'dir_action': 'navigate',
      },
    );

    try {
      final launched = await launchUrl(
        navigationUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!context.mounted) return;

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Google Maps.'),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Google Maps navigation failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open Google Maps navigation.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 16,
      child: SafeArea(
        child: FilledButton.icon(
          onPressed: () => _openGoogleMapsNavigation(context),
          icon: const Icon(Icons.navigation, size: 18),
          label: const Text('Navigate'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}