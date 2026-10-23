import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class StaticDestination {
  final String name;
  final LatLng coordinates;

  const StaticDestination({required this.name, required this.coordinates});
}

class RouteSearchScreen extends StatefulWidget {
  final LatLng pickup;
  final String pickupAddress;
  const RouteSearchScreen({
    super.key,
    required this.pickup,
    required this.pickupAddress,
  });

  @override
  State<RouteSearchScreen> createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends State<RouteSearchScreen> {
  StaticDestination? _destination;

  final List<StaticDestination> _destinations = const [
    StaticDestination(
      name: 'Faisal Mosque, Islamabad',
      coordinates: LatLng(33.7295, 73.0372),
    ),
    StaticDestination(
      name: 'Centaurus Mall, Islamabad',
      coordinates: LatLng(33.7077, 73.0501),
    ),
    StaticDestination(
      name: 'Pakistan Monument, Islamabad',
      coordinates: LatLng(33.6939, 73.0657),
    ),
    StaticDestination(
      name: 'Daman-e-Koh, Islamabad',
      coordinates: LatLng(33.7435, 73.0551),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Enter your route',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Pickup location
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F0EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin_circle, size: 30),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'From',
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your current location',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.pickupAddress,

                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Destination selection
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _showDestinationPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F0EB),
                    border: Border.all(
                      color: _destination == null
                          ? Colors.black
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 30),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _destination?.name ?? 'Choose destination',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Next step
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _destination == null
                      ? null
                      : () {
                          Navigator.pop<StaticDestination>(
                            context,
                            _destination!,
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7900),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDestinationPicker() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Choose destination',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),
              ..._destinations.map((destination) {
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(destination.name),
                  trailing: _destination?.name == destination.name
                      ? const Icon(Icons.check_circle, color: Colors.orange)
                      : null,
                  onTap: () {
                    setState(() {
                      _destination = destination;
                    });

                    Navigator.pop(sheetContext);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
