import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/bloc/logout/logout_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/logout/logout_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/logout/logout_state.dart';
import 'package:star_drive/features/auth/presentation/screens/login_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/dashboard/presentation/screens/profile/profile_setting_screen.dart';

import '../../../../auth/data/dataresource/local/auth_local_data_storage.dart';
import '../../../../become_driver/presentation/screen/become_driver_screen.dart' show BecomeDriverScreen;

// import 'package:star_drive/features/history/presentation/screen/history_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthLocalStorage().getUser();

    final userName = user?.name ?? 'Guest';
    final rating = user?.passengerRating ?? 0.0;
    final isDriver = user?.isDriver ?? false;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileSettingScreen(userName: userName),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, size: 38, color: Colors.grey),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.star, size: 18, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1), 
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Drawer Items
            _drawerItem(
              context,
              icon: FontAwesomeIcons.wallet,
              title: 'Wallet',
            ),
            _drawerItem(
              context,
              icon: FontAwesomeIcons.cableCar,
              title: 'History',
              onTap: () {
                //   Navigator.pop(context);

                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => const HistoryScreen()),
                //   );
              },
            ),
            _drawerItem(
              context,
              icon: FontAwesomeIcons.bell,
              title: 'Notification',
            ),
            _drawerItem(
              context,
              icon: FontAwesomeIcons.shieldHalved,
              title: 'Safety',
            ),
            _drawerItem(
              context,
              icon: FontAwesomeIcons.gear,
              title: 'Settings',
            ),
            _drawerItem(
              context,
              icon: FontAwesomeIcons.circleInfo,
              title: 'Help',
            ),
            _drawerItem(
              context,
              icon: FontAwesomeIcons.commentDots,
              title: 'Support',
            ),

            const SizedBox(height: 190),

            // Divider
            Divider(height: 1, color: Colors.grey[300]),

            const SizedBox(height: 40),
            BlocProvider(
              create: (_) => sl<LogoutBloc>(),
              child: BlocConsumer<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  if (state is LogoutSuccess) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  }

                  if (state is LogoutFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final isLoading = state is LogoutLoading;

                  return TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<LogoutBloc>().add(
                              const LogoutRequested(),
                            );
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('SignOut'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AuthButton(
                    text: isDriver ? 'Passenger Mode' : 'Driver Mode',

                isLoading: false,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>BecomeDriverScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Drawer Item
  Widget _drawerItem(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: FaIcon(icon, size: 18, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
    );
  }
}
