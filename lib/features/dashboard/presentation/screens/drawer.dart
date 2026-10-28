// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:star_drive/core/constant/app_colors.dart';
// import 'package:star_drive/features/dashboard/presentation/screens/user_profile_setting_screen.dart';
// import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/screens/ride_history_screen.dart';
// import 'package:star_drive/features/theme/presentation/bloc/theme_bloc.dart';
// import 'package:star_drive/features/theme/presentation/bloc/theme_event.dart';
// import 'package:star_drive/features/theme/presentation/bloc/theme_state.dart';

// class DrawerScreen extends StatefulWidget {
//   const DrawerScreen({super.key, required this.userName});

//   final String userName;

//   @override
//   State<DrawerScreen> createState() => _DrawerScreenState();
// }

// class _DrawerScreenState extends State<DrawerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final textColor = isDark ? Colors.white : AppColors.textPrimary;

//     final iconColor = isDark ? Colors.white70 : AppColors.textSecondary;

//     return Drawer(
//       backgroundColor: isDark ? AppColors.darkThemeBg : AppColors.surface,
//       child: ListTileTheme(
//         data: ListTileThemeData(textColor: textColor, iconColor: iconColor),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Light / Dark toggle
//               BlocBuilder<ThemeBloc, ThemeState>(
//                 builder: (context, state) {
//                   final darkMode = state.mode == ThemeMode.dark;

//                   return SwitchListTile(
//                     secondary: Icon(
//                       darkMode ? Icons.dark_mode : Icons.light_mode,
//                     ),
//                     title: Text(darkMode ? 'Dark mode' : 'Light mode'),
//                     subtitle: const Text('Change app appearance'),
//                     value: darkMode,
//                     onChanged: (value) {
//                       context.read<ThemeBloc>().add(
//                         ThemeModeChanged(
//                           value ? ThemeMode.dark : ThemeMode.light,
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),

//               Divider(height: 1, color: Theme.of(context).dividerColor),

//               // Profile
//               ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(
//                   widget.userName.isEmpty ? 'My Profile' : widget.userName,
//                 ),

//                 onTap: () => _openPage(context, const ProfileSettingScreen()),
//               ),

//               Divider(height: 1, color: Theme.of(context).dividerColor),

//               // Baqi existing menu items
//               _DrawerItem(
//                 icon: Icons.account_balance_wallet_outlined,
//                 title: 'Wallet',
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               _DrawerItem(
//                 icon: Icons.history,
//                 title: 'History',
//                 onTap: () => _openPage(context, const HistoryScreen()),
//               ),
//               _DrawerItem(
//                 icon: Icons.notifications_outlined,
//                 title: 'Notification',
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               _DrawerItem(
//                 icon: Icons.shield_outlined,
//                 title: 'Safety',
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               _DrawerItem(
//                 icon: Icons.settings_outlined,
//                 title: 'Settings',
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               _DrawerItem(
//                 icon: Icons.help_outline,
//                 title: 'Help',
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//               _DrawerItem(
//                 icon: Icons.support_agent_outlined,
//                 title: 'Support',
//                 onTap: () => Navigator.of(context).pop(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _openPage(BuildContext context, Widget page) {
//     final navigator = Navigator.of(context);
//     navigator.pop();
//     navigator.push(MaterialPageRoute<void>(builder: (_) => page));
//   }
// }

// class _DrawerItem extends StatelessWidget {
//   const _DrawerItem({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, size: 20),
//       title: Text(title),
//       onTap: onTap,
//     );
//   }
// }
