import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:star_drive/core/constant/app_images.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/map/data/datasource/route_datasource.dart';

import 'package:star_drive/features/map/presentation/screen/widgets/google_map_navigation.dart';
import 'package:star_drive/features/map/presentation/screen/widgets/map_render_screen.dart';

import 'package:star_drive/features/map/presentation/screen/widgets/search_destination_widget.dart';

import '../../domain/entities/ride_estimate_request_entity.dart';
import '../../domain/entities/ride_estimate_response_entity.dart';
import '../bloc/map_bloc/map_bloc.dart';
import '../bloc/ride_estimate/ride_estimate_bloc.dart';
import '../bloc/ride_estimate/ride_estimate_event.dart';
import '../bloc/ride_estimate/ride_estimate_state.dart';
import '../utils/polyline_decoder.dart';
import 'widgets/fare_selection_widgets.dart';
import 'widgets/route_summary_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  MapLibreMapController? _controller;

  bool _styleLoaded = false; // Add this line

  bool _markerAdded = false;
  bool _settingsOpened = false;
  bool _routeAvailable = false;
  String _pickupName = 'Current location';
  String _destinationName = '';
  int _estimatedMinutes = 0;
  LatLng? _selectedDestination;

  final Geocoding geocoding = Geocoding();
  // late final RouteDataSource _routeDataSource;
  @override
  void initState() {
    super.initState();
    // _routeDataSource = sl<RouteDataSource>();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _settingsOpened) {
      _settingsOpened = false;

      if (mounted) {
        context.read<MapBloc>().add(const RetryLocationEvent());
      }
    }
  }

  Future<void> _addUserMarker(Position position) async {
    if (_controller == null || !_styleLoaded || _markerAdded) {
      return;
    }

    final location = LatLng(position.latitude, position.longitude);

    await _controller!.animateCamera(CameraUpdate.newLatLngZoom(location, 16));

    await _controller!.addCircle(
      CircleOptions(
        geometry: location,
        circleRadius: 8,
        circleColor: '#1565C0',
        circleStrokeWidth: 2,
        circleStrokeColor: '#FFFFFF',
      ),
    );

    _markerAdded = true;
  }

  void _onMapCreated(MapLibreMapController controller) {
    _controller = controller;
  }

  Future<void> _onStyleLoaded() async {
    _styleLoaded = true;

    final state = context.read<MapBloc>().state;

    if (state is MapLocationSuccess) {
      await _addUserMarker(state.position);
    }
  }

  Future<void> _addDestinationMarker(LatLng destination) async {
    final controller = _controller;

    if (controller == null || !_styleLoaded) return;

    try {
      // load Flutter asset in bytes
      final ByteData byteData = await rootBundle.load(
        AppImages.destinationIcon,
      );

      final Uint8List imageBytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      // Register  image in library
      await controller.addImage('destination-marker', imageBytes);

      // show marker on  Destination location
      await controller.addSymbol(
        SymbolOptions(
          geometry: destination,
          iconImage: 'destination-marker',
          iconSize: 0.3,
          iconAnchor: 'bottom',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Destination marker failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        // Permission required
        title: const Text('Location Permission Required'),
        content: const Text(
          'StarDrive needs access to your current location '
          'to display the map at your location.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MapBloc>().add(
                const RequestLocationPermissionEvent(),
              );
            },
            child: const Text('Allow location'),
          ),
        ],
      ),
    );
  }

  void _showPermanentDenialDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location permission blocked'),
        content: const Text(
          'Location permission Settings mein enable karein '
          'taake map aapki current location par open ho sake.',
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
              _settingsOpened = true;
              context.read<MapBloc>().add(const OpenAppSettingsEvent());
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showLocationServiceDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        // Permanently denied
        title: const Text('Location Permission Denied'),
        content: const Text(
          'Location permission has been permanently denied. '
          'Please enable it in your app settings to continue.',
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
              _settingsOpened = true;
              context.read<MapBloc>().add(const OpenLocationSettingsEvent());
            },
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
  }

  void _showCarFareSelection({
    required String pickupName,
    required String destinationName,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<RideEstimateBloc>(),
          child: FareSelectionSheet(
            onFindDrivers: (vehicleId, fare, autoAccept) {
              Navigator.of(sheetContext).pop();

              // Next step: ride request API call
            },
            onRetry: () {
              // Retry handling, if required
            },
          ),
        );
      },
    );
  }

  Future<void> drawRouteFromEstimate(RideEstimateEntity estimate) async {
    final controller = _controller;

    if (controller == null || !_styleLoaded) {
      debugPrint('Map is not ready.');
      return;
    }

    try {
      final routePoints = PolylineDecoder.decode(
        estimate.polyline,
        precision: estimate.polylinePrecision,
      );

      if (routePoints.isEmpty) return;

      await controller.clearLines();
      await controller
          .clearSymbols(); // purana destination marker hatane ke liye

      await controller.addLine(
        LineOptions(
          geometry: routePoints,
          lineColor: '#FF7900',
          lineWidth: 5,
          lineOpacity: 0.95,
          lineJoin: 'round',
        ),
      );

      // Destination marker = route ka last point
      await _addDestinationMarker(routePoints.last);

      // Bounds API se aa rahe hain, dobara calculate karne ki zaroorat nahi
      final bounds = LatLngBounds(
        southwest: LatLng(estimate.bounds.minLat, estimate.bounds.minLon),
        northeast: LatLng(estimate.bounds.maxLat, estimate.bounds.maxLon),
      );

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          left: 55,
          top: 100,
          right: 55,
          bottom: 250,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Route draw failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not draw route. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapPermissionRequired) {
            _showPermissionDialog(context);
          } else if (state is MapPermissionPermanentlyDenied) {
            _showPermanentDenialDialog(context);
          } else if (state is MapLocationServiceDisabled) {
            _showLocationServiceDialog(context);
          } else if (state is MapLocationSuccess) {
            _addUserMarker(state.position);
          } else if (state is MapLocationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MapLocationSuccess) {
            final position = state.position;

            return BlocListener<RideEstimateBloc, RideEstimateState>(
              listener: (context, state) {
                if (state is RideEstimateSuccess) {
                  drawRouteFromEstimate(state.estimate);
                }
              },
              child: Stack(
                children: [
                  MapRenderScreen(
                    position: position,
                    onMapCreated: _onMapCreated,
                    onStyleLoaded: _onStyleLoaded,
                  ),

                  if (_routeAvailable && _selectedDestination != null)
                    GoogleMapNavigation(
                      selectedDestination: _selectedDestination!,
                    ),

                  SearchDestinationWidget(
                    position: position,
                    onDestinationSelected: (destination)async  {
                        if (!mounted) return;
                      setState(() {
                        _selectedDestination = destination.coordinates;
                        _destinationName = destination.name;
                        _routeAvailable = true;
                      });

                      context.read<RideEstimateBloc>().add(
                        RideEstimateRequested(
                          RideEstimateRequestEntity(
                            vehicleType:
                                'car', 
                            pickup: RideEstimateLocationEntity(
                              lat: position.latitude,
                              lon: position.longitude,
                              name: _pickupName,
                            ),
                            drop: RideEstimateLocationEntity(
                              lat: destination.coordinates.latitude,
                              lon: destination.coordinates.longitude,
                              name: destination.name,
                            ),
                          ),
                        ),
                      );

                      _showCarFareSelection(
                        pickupName: _pickupName,
                        destinationName: destination.name,
                      );
                    },
                  ),
                  if (_routeAvailable)
                    BlocBuilder<RideEstimateBloc, RideEstimateState>(
                      builder: (context, estimateState) {
                        if (estimateState is! RideEstimateSuccess) {
                          return const SizedBox.shrink();
                        }

                        final estimate = estimateState.estimate;

                        return RouteSummaryCard(
                          pickupName: _pickupName,
                          destinationName: _destinationName,
                          estimatedMinutes: estimate.durationMin,
                          distanceKm: estimate.distanceKm,
                        );
                      },
                    ),
                ],
              ),
            );
          }

          if (state is MapLocationFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_off, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<MapBloc>().add(const RetryLocationEvent());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Getting your location...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
