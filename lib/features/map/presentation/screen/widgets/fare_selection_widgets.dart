import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/map/domain/entities/ride_estimate_response_entity.dart';
import 'package:star_drive/features/map/presentation/bloc/ride_estimate/ride_estimate_bloc.dart';
import 'package:star_drive/features/map/presentation/bloc/ride_estimate/ride_estimate_state.dart';

class FareSelectionSheet extends StatelessWidget {
  final VoidCallback onRetry;

  final void Function(
    RideEstimateEntity estimate,
    double fare,
    bool autoAccept,
  ) onFindDrivers;

  const FareSelectionSheet({
    super.key,
    required this.onRetry,
    required this.onFindDrivers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5DD),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 14),
            BlocBuilder<RideEstimateBloc, RideEstimateState>(
              builder: (context, state) {
                if (state is RideEstimateLoading ||
                    state is RideEstimateInitial) {
                  return const SizedBox(
                    height: 260,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is RideEstimateFailure) {
                  return SizedBox(
                    height: 260,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 44,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: onRetry,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (state is RideEstimateSuccess) {
                  return _FareContent(
                    key: ValueKey(state.estimate.estimateId),
                    estimates: [state.estimate],
                    onFindDrivers: onFindDrivers,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
class _FareContent extends StatefulWidget {
  final List<RideEstimateEntity> estimates;
  final void Function(RideEstimateEntity, double, bool) onFindDrivers;

  const _FareContent({
    super.key,
    required this.estimates,
    required this.onFindDrivers,
  });

  @override
  State<_FareContent> createState() => _FareContentState();
}

class _FareContentState extends State<_FareContent> {
  int _selectedIndex = 0;
  bool _autoAccept = false;
  late final List<double> _fares;

  @override
  void initState() {
    super.initState();
    // Starting fare = API ka suggestedFare
    _fares = widget.estimates.map((e) => e.suggestedFare.toDouble()).toList();
  }

  RideEstimateEntity get _selected => widget.estimates[_selectedIndex];
  double get _currentFare => _fares[_selectedIndex];

  void _changeFare(double delta) {
    final min = _selected.minimumOffer.toDouble(); // API ka minimumOffer
    final next = _currentFare + delta;

    if (next < min) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minimum offer is ${_selected.currency} ${min.toStringAsFixed(0)}',
          ),
        ),
      );
      return;
    }
    setState(() => _fares[_selectedIndex] = next);
  }

  IconData _iconFor(String type) {
    switch (type.toLowerCase()) {
      case 'moto':
      case 'bike':
        return Icons.two_wheeler;
      case 'ac':
        return Icons.ac_unit;
      default:
        return Icons.directions_car_filled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = _selected.currency;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: widget.estimates.length,
            itemBuilder: (context, index) {
              final e = widget.estimates[index];
              return index == _selectedIndex
                  ? _buildSelectedCard(e, index)
                  : _buildOptionRow(e, index);
            },
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEDEDE6)),

        // Auto accept
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 16, 0),
          child: Row(
            children: [
              const Icon(Icons.near_me, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Auto-accept offer of $currency ${_currentFare.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Switch(
                value: _autoAccept,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                onChanged: (v) => setState(() => _autoAccept = v),
              ),
            ],
          ),
        ),

        // Find drivers
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
          child: Row(
            children: [
              const Icon(Icons.payments, color: Color(0xFF2E9E44)),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => widget.onFindDrivers(
                      _selected,
                      _currentFare,
                      _autoAccept,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Find drivers',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
            ],
          ),
        ),
      ],
    );
  }

  // Selected: highlighted card + fare selector
  Widget _buildSelectedCard(RideEstimateEntity e, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _vehicleIcon(e, selected: true),
              const SizedBox(width: 12),
              Expanded(child: _vehicleTexts(e)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _FareButton(icon: Icons.remove, onTap: () => _changeFare(-10)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        '${e.currency} ${_fares[index].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'Min ${e.currency} ${e.minimumOffer.toStringAsFixed(0)}',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _FareButton(icon: Icons.add, onTap: () => _changeFare(10)),
            ],
          ),
        ],
      ),
    );
  }

  // Unselected: simple row
  Widget _buildOptionRow(RideEstimateEntity e, int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _selectedIndex = index),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            _vehicleIcon(e, selected: false),
            const SizedBox(width: 12),
            Expanded(child: _vehicleTexts(e)),
            Text(
              '~${e.currency} ${_fares[index].toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleIcon(RideEstimateEntity e, {required bool selected}) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: selected ? Colors.white : const Color(0xFFF5F5EF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(_iconFor(e.vehicleType),
          size: 42, color: const Color(0xFF444444)),
    );
  }

  Widget _vehicleTexts(RideEstimateEntity e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          e.vehicleType,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            const Icon(Icons.schedule, size: 16),
            const SizedBox(width: 4),
            Text('${e.durationMin} min', style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          '${e.distanceKm.toStringAsFixed(1)} km',
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }
}

class _FareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _FareButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 54, height: 54, child: Icon(icon, size: 28)),
      ),
    );
  }
}