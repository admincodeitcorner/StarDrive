import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/dashboard/presentation/screens/profile/profile_setting_screen.dart';
// import 'package:star_drive/features/history/presentation/screen/history_screen.dart';

class DrawerScreen extends StatelessWidget {
  final String userName;
  const DrawerScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
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
                                '5.0',
                                style: TextStyle(
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AuthButton(
                text: 'Passenger Mode',
                isLoading: false,
                onPressed: () {},
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
