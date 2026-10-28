import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/dashboard/domain/entities/ride_history.dart';
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_bloc.dart';
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_event.dart';
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HistoryBloc>()..add(const HistoryRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ride History'), centerTitle: true),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryFailure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HistoryBloc>().add(
                          const HistoryRequested(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HistorySuccess) {
              final rides = state.history.rides;

              if (rides.isEmpty) {
                return const Center(child: Text('No ride history found.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  return _RideHistoryCard(ride: rides[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _RideHistoryCard extends StatelessWidget {
  final RideHistoryItem ride;

  const _RideHistoryCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    final isCancelled = ride.status.toLowerCase() == 'cancelled';
    // Current theme check karo.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // AppColors se success aur error colors lo.
    final statusColor = isCancelled ? AppColors.error : AppColors.success;

    // Status chip ka background theme ke mutabiq halka rakho.
    final statusBackgroundColor = statusColor.withValues(
      alpha: isDark ? 0.22 : 0.14,
    );

    // Dark aur Light mode mein readable text color.
    final statusTextColor = isDark
        ? Color.lerp(statusColor, Colors.white, 0.3)!
        : statusColor;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ride #${ride.rideId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    ride.status,
                    style: TextStyle(color: statusTextColor),
                  ),
                  backgroundColor: statusBackgroundColor,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('📍 Pickup: ${ride.pickupName}'),
            const SizedBox(height: 6),
            Text('🏁 Drop-off: ${ride.dropName}'),
            const SizedBox(height: 6),
            Text('👤 ${ride.otherPartyName}'),
            const SizedBox(height: 6),
            Text(
              'Date: ${ride.rideDate.day}/${ride.rideDate.month}/${ride.rideDate.year}',
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Text(
                  'Fare',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  'Rs. ${ride.fare.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (ride.cancelReason != null && ride.cancelReason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Cancel reason: ${ride.cancelReason}'),
            ],
          ],
        ),
      ),
    );
  }
}
