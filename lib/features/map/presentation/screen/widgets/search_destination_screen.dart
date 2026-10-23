import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:star_drive/features/map/presentation/screen/widgets/route_search_screen.dart';

class SearchDestinationScreen extends StatelessWidget {
  SearchDestinationScreen({
    super.key,
    required this.position,
    required this.onDestinationSelected,
  });

  final Position position;
  final Future<void> Function(StaticDestination destination)
  onDestinationSelected;

  final Geocoding geocoding = Geocoding();

  Future<String> _getPickupAddress(Position position) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return 'Current location';
      }

      final place = placemarks.first;

      final parts =
          [
                place.name,
                place.subLocality,
                place.locality,
                place.administrativeArea,
              ]
              .whereType<String>()
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .toSet()
              .toList();

      return parts.isEmpty ? 'Current location' : parts.join(', ');
    } catch (e, stackTrace) {
      debugPrint('Reverse geocoding failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      return 'Current location';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: SafeArea(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          elevation: 6,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              final pickupAddress = await _getPickupAddress(position);

              if (!context.mounted) return;

              final destination = await Navigator.push<StaticDestination>(
                context,
                MaterialPageRoute(
                  builder: (_) => RouteSearchScreen(
                    pickup: LatLng(position.latitude, position.longitude),
                    pickupAddress: pickupAddress,
                  ),
                ),
              );

              if (!context.mounted || destination == null) return;

              debugPrint('Destination: ${destination.name}');
              debugPrint(
                'Coordinates: ${destination.coordinates.latitude}, '
                '${destination.coordinates.longitude}',
              );

              await onDestinationSelected(destination);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Row(
                children: [
                  Icon(Icons.search, size: 30),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Where to & for how much?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
