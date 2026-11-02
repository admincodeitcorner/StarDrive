import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../driver_import.dart';
import '../../../map/map_import.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/signalr/location_sender.dart';
import '../../../../core/signalr/signalr_service.dart';
import '../../../dashboard/presentation/screens/widgets/drawer.dart';
import '../../../widgets/permisson_dialog.dart';
import '../../../widgets/show_permanent_denial_dialog.dart';
import '../../../widgets/location_service_dialog.dart';

import 'widgets/custom_navigation_bar.dart';
import 'widgets/custom_toggle_button.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  bool _settingsOpened = false;
  // bool _dialogShowing = false;
  bool _isProcessing = false;
  int? _loadingIndex;
  StreamSubscription<Position>? _locationSubscription;

  bool _isStartingLocationTracking = false;
  bool _isSendingLocation = false;
  final List<Widget> _screens = const [
    Center(child: Text('Ride Request')),
    Center(child: Text('Demand')),
    Center(child: Text('Performance')),
    Center(child: Text('Wallet')),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Only fetch the current location here.
    context.read<MapBloc>().add(const InitializeMapEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    final subscription = _locationSubscription;
    _locationSubscription = null;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }

    super.dispose();
  }

  // Re-check the location when the user returns from the settings screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _settingsOpened) {
      _settingsOpened = false;

      if (mounted) {
        context.read<MapBloc>().add(const RetryLocationEvent());
      }
    }
  }

  void _mapState(BuildContext context, MapState mapState) {
    if (mapState is MapPermissionRequired) {
      showPermissionDialog(context);
    } else if (mapState is MapPermissionPermanentlyDenied) {
      showPermanentDenialDialog(context);
    } else if (mapState is MapLocationServiceDisabled) {
      showLocationServiceDialog(context);
    } else if (mapState is MapLocationFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapState.message)));
    }
  }

  void _driverAvailabilityState(
    BuildContext context,
    DriverAvailabilityState driverAvailabilityState,
  )  {
    if (!driverAvailabilityState.isLoading && _isProcessing) {
      setState(() {
        _isProcessing = false;
        _loadingIndex = null;
      });
    }
    // Start or stop GPS tracking only after the
    // availability request succeeds.
    if (!driverAvailabilityState.isLoading &&
        driverAvailabilityState.messageType ==
            AvailabilityMessageType.success) {
      if (driverAvailabilityState.isOnline) {
        unawaited(_startLocationTracking());
      } else {
        unawaited(_stopLocationTracking());
      }
    }
    if (driverAvailabilityState.message != null &&
        driverAvailabilityState.messageType != AvailabilityMessageType.none) {
      final isSuccess =
          driverAvailabilityState.messageType ==
          AvailabilityMessageType.success;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(driverAvailabilityState.message!),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
      );
    }
  }
Future<void> _handleAvailabilityToggle(int index) async {
    if (!mounted || _isProcessing) return;

    final mapBloc = context.read<MapBloc>();
    final availabilityBloc = context.read<DriverAvailabilityBloc>();
    final currentState = availabilityBloc.state;

    // Prevent another request while the BLoC is already processing one.
    if (currentState.isLoading) return;

    // Ignore taps on the already-selected option.
    if ((index == 1 && currentState.isOnline) ||
        (index == 0 && !currentState.isOnline)) {
      return;
    }

    // This local state only locks the button while GPS is being obtained.
    setState(() {
      _isProcessing = true;
      _loadingIndex = index;
    });

    var dispatched = false;

    try {
      // 1. Check whether the device location service is enabled.
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;

      if (!serviceEnabled) {
        mapBloc.add(const RetryLocationEvent());
        return;
      }

      // 2. Check/request location permission.
      var permission = await Geolocator.checkPermission();
      if (!mounted) return;

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        mapBloc.add(const RetryLocationEvent());
        return;
      }

      // 3. Try the last known location first.
      Position? position = await Geolocator.getLastKnownPosition();
      if (!mounted) return;

      // Use MapBloc's cached position as the next fallback.
      if (position == null && mapBloc.state is MapLocationSuccess) {
        position = (mapBloc.state as MapLocationSuccess).position;
      }

      // Get a fresh position only when no cached position is available.
      if (position == null) {
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 5),
            ),
          );
        } catch (_) {
          if (!mounted) return;

          // Retry once with lower accuracy for a quicker fix.
          try {
            position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.low,
                timeLimit: Duration(seconds: 4),
              ),
            );
          } catch (_) {
            // The null-position handling below displays the error.
          }
        }
      }

      if (!mounted) return;

      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Current location nahi mil saki. GPS check karein.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        mapBloc.add(const RetryLocationEvent());
        return;
      }

      // 4. Dispatch the API request. The BLoC's isLoading state takes over
      // the busy indicator; the local flag is cleared by the listener.
      dispatched = true;
      if (index == 1) {
        availabilityBloc.add(
          SetDriverOnlineRequested(
            lat: position.latitude,
            lon: position.longitude,
          ),
        );
      } else {
        availabilityBloc.add(
          SetDriverOfflineRequested(
            lat: position.latitude,
            lon: position.longitude,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Once dispatched, _driverAvailabilityState clears this flag when
      // the BLoC finishes. For all early exits/errors, clear it here.
      if (mounted && !dispatched) {
        setState(() {
          _isProcessing = false;
          _loadingIndex = null;
        });
      }
    }
  }
  Future<void> _startLocationTracking() async {
    if (_locationSubscription != null || _isStartingLocationTracking) {
      return;
    }

    _isStartingLocationTracking = true;

    try {
      debugPrint('LOCATION: Starting SignalR connection...');

      try {
        await sl<SignalRService>().connect();
        debugPrint(
          'SIGNALR: Connected = '
          '${sl<SignalRService>().isConnected}',
        );
      } catch (error, stackTrace) {
        debugPrint('SIGNALR CONNECT FAILED: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      if (!mounted) return;

      // Start listening for subsequent GPS updates.
      _locationSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen(
            (position) {
              debugPrint(
                'GPS UPDATE: '
                '${position.latitude}, ${position.longitude}',
              );

              unawaited(_sendDriverLocation(position));
            },
            onError: (Object error) {
              debugPrint('GPS STREAM ERROR: $error');
            },
          );

      // Send an initial location immediately.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      debugPrint('INITIAL GPS: ${position.latitude}, ${position.longitude}');

      await _sendDriverLocation(position);
    } catch (error, stackTrace) {
      debugPrint('LOCATION TRACKING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isStartingLocationTracking = false;
    }
  }

  Future<void> _sendDriverLocation(Position position) async {
    if (_isSendingLocation) {
      debugPrint('LOCATION: Previous request still running');
      return;
    }

    _isSendingLocation = true;

    try {
      debugPrint(
        'LOCATION SENDING: '
        '${position.latitude}, ${position.longitude}',
      );

      await sl<DriverLocationSender>().sendLocation(
        lat: position.latitude,
        lon: position.longitude,
      );

      debugPrint('LOCATION SENT SUCCESSFULLY');
    } catch (error, stackTrace) {
      debugPrint('LOCATION SEND FAILED: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isSendingLocation = false;
    }
  }

  Future<void> _stopLocationTracking() async {
    final subscription = _locationSubscription;
    _locationSubscription = null;

    await subscription?.cancel();

    try {
      await sl<SignalRService>().disconnect();
    } catch (error) {
      debugPrint('SignalR disconnect failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Handles location permission / service / failure side effects.
        BlocListener<MapBloc, MapState>(listener: _mapState),

        // Shows a snackbar whenever the availability bloc emits a message.
        BlocListener<DriverAvailabilityBloc, DriverAvailabilityState>(
          listener: _driverAvailabilityState,
        ),
      ],
      child: Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: BlocBuilder<DriverAvailabilityBloc, DriverAvailabilityState>(
            builder: (context, availability) {
              final isOnline = availability.isOnline;
              final isBusy = _isProcessing || availability.isLoading;

            return CustomToggleButton(
                isOnline: isOnline,
                isBusy: isBusy,
                loadingIndex: _loadingIndex,
                onPressed: _handleAvailabilityToggle,
              );
            },
          ),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

