
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons, FaIconData, FaIcon;
import 'package:star_drive/features/auth/presentation/bloc/logout/logout_event.dart' show LogoutRequested;
import 'package:star_drive/features/become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_state.dart' show OnboardingState, OnboardingFailure, OnboardingSuccess, OnboardingLoading;

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/di/injector.dart';
import '../../../../auth/data/dataresource/local/auth_local_data_storage.dart';
import '../../../../auth/presentation/bloc/logout/logout_bloc.dart' show LogoutBloc;
import '../../../../auth/presentation/bloc/logout/logout_state.dart';
import '../../../../auth/presentation/screens/login_screen.dart';
import '../../../../auth/presentation/widgets/custom_auth_button.dart';
import '../../../../become_driver/domain/enum/onboard_status_enum.dart';
import '../../../../become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_bloc.dart';
import '../../../../become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_event.dart' show OnboardingStatusRequested;
import '../../../../become_driver/presentation/screen/become_driver_screen.dart' show BecomeDriverScreen;
import '../../../../driver_verification/presentataion/screen/driver_verification_screen.dart';
import '../../../../driver_verification/presentataion/screen/vechile_detail_screen.dart' show VechileDetailScreen;
import '../../../../theme/presentation/bloc/theme_bloc.dart' show ThemeBloc;
import '../../../../theme/presentation/bloc/theme_event.dart';
import '../../../../theme/presentation/bloc/theme_state.dart';
import '../ride_history/presentation/screens/ride_history_screen.dart' show HistoryScreen;
import '../user_profile_setting_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthLocalStorage().getUser();

    final userName = user?.name ?? 'Guest';
    final rating = user?.passengerRating ?? 0.0;
    final isDriver = user?.isDriver ?? false;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.mode == ThemeMode.dark;

        final backgroundColor = isDark
            ? AppColors.darkThemeBg
            : AppColors.surface;

        final textColor = isDark
            ? Colors.white
            : AppColors.textPrimary;

        final secondaryTextColor = isDark
            ? Colors.white70
            : AppColors.textSecondary;

        final dividerColor = isDark
            ? Colors.white24
            : Colors.grey.shade300;

        return Drawer(
          backgroundColor: backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                // Light / Dark Theme Toggle
                SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: textColor,
                  ),
                  title: Text(
                    isDark ? 'Dark mode' : 'Light mode',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Change app appearance',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                  value: isDark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(
                      ThemeModeChanged(
                        value ? ThemeMode.dark : ThemeMode.light,
                      ),
                    );
                  },
                ),

                Divider(height: 1, color: dividerColor),

                // Profile Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileSettingScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: isDark
                              ? Colors.white12
                              : const Color(0xFFE0E0E0),
                          child: Icon(
                            Icons.person,
                            size: 38,
                            color: secondaryTextColor,
                          ),
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
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileSettingScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(height: 1, color: dividerColor),

                // Drawer Items
                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.wallet,
                  title: 'Wallet',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                ),

                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.cableCar,
                  title: 'History',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                    onTap: () =>Navigator.push(context, 
                    MaterialPageRoute(builder: (_)=>HistoryScreen())) ),
              
                

                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.bell,
                  title: 'Notification',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                ),

                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.shieldHalved,
                  title: 'Safety',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                ),

                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.gear,
                  title: 'Settings',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                ),

                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.circleInfo,
                  title: 'Help',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                ),

                _drawerItem(
                  context,
                  icon: FontAwesomeIcons.commentDots,
                  title: 'Support',
                  textColor: textColor,
                  iconColor: secondaryTextColor,
                ),

                const Spacer(),

                Divider(height: 1, color: dividerColor),

                const SizedBox(height: 16),

                // Logout - Existing Bloc
                BlocProvider(
                  create: (_) => sl<LogoutBloc>(),
                  child: BlocConsumer<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      if (state is LogoutSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }

                      if (state is LogoutFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is LogoutLoading;

                      return TextButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<LogoutBloc>().add(
                                  const LogoutRequested(),
                                );
                              },
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.logout),
                        label: Text(
                          isLoading ? 'Signing out...' : 'Sign Out',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Become a Driver - Existing Onboarding Bloc
                BlocProvider(
                  create: (_) => sl<OnboardingBloc>(),
                  child: BlocConsumer<OnboardingBloc, OnboardingState>(
                    listener: (context, state) {
                      if (state is OnboardingFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }

                      if (state is OnboardingSuccess) {
                        Navigator.pop(context);

                        final destination =
                            getNextOnboardingDestination(state.status);

                        switch (destination) {
                          case OnboardingDestination.profile:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BecomeDriverScreen(),
                              ),
                            );
                            break;

                          case OnboardingDestination.documents:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DriverVerificationScreen(),
                              ),
                            );
                            break;

                          case OnboardingDestination.vehicle:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VechileDetailScreen(),
                              ),
                            );
                            break;

                          case OnboardingDestination.dashboard:
                            // Driver dashboard navigation yahan add karein.
                            break;
                        }
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is OnboardingLoading;

                      return AuthButton(
                        text: isDriver
                            ? 'Driver Mode'
                            : 'Become a Driver',
                        isLoading: isLoading,
                        onPressed: () {
                          if (isLoading) return;

                          if (isDriver) {
                            context.read<OnboardingBloc>().add(
                              OnboardingStatusRequested(),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BecomeDriverScreen(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required Color textColor,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: 0,
        vertical: -2,
      ),
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 0,
      ),
      leading: FaIcon(icon, size: 18, color: iconColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 15, color: textColor),
      ),
      onTap: onTap ?? () {},
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:star_drive/core/di/injector.dart';
// import 'package:star_drive/features/auth/presentation/bloc/logout/logout_bloc.dart';
// import 'package:star_drive/features/auth/presentation/bloc/logout/logout_event.dart';
// import 'package:star_drive/features/auth/presentation/bloc/logout/logout_state.dart';
// import 'package:star_drive/features/auth/presentation/screens/login_screen.dart';
// import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';


// import '../../../../auth/data/dataresource/local/auth_local_data_storage.dart';
// import '../../../../become_driver/domain/enum/onboard_status_enum.dart';
// import '../../../../become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_bloc.dart';
// import '../../../../become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_event.dart';
// import '../../../../become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_state.dart' show OnboardingState, OnboardingFailure, OnboardingSuccess, OnboardingLoading;
// import '../../../../become_driver/presentation/screen/become_driver_screen.dart' show BecomeDriverScreen;
// import '../../../../driver_verification/presentataion/screen/driver_verification_screen.dart';
// import '../../../../driver_verification/presentataion/screen/vechile_detail_screen.dart';
// import '../user_profile_setting_screen.dart';

// // import 'package:star_drive/features/history/presentation/screen/history_screen.dart';

// class DrawerScreen extends StatelessWidget {
//   const DrawerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = AuthLocalStorage().getUser();

//     final userName = user?.name ?? 'Guest';
//     final rating = user?.passengerRating ?? 0.0;
//     final isDriver = user?.isDriver ?? false;

//     return Drawer(
//       child: SafeArea(
//         child: Column(
//           children: [
//             // Profile Header
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: InkWell(
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => ProfileSettingScreen(),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Color(0xFFE0E0E0),
//                       child: Icon(Icons.person, size: 38, color: Colors.grey),
//                     ),

//                     const SizedBox(width: 12),

//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             userName,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 6),
//                           Row(
//                             children: [
//                               Icon(Icons.star, size: 18, color: Colors.amber),
//                               SizedBox(width: 4),
//                               Text(
//                                 rating.toStringAsFixed(1), 
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.arrow_forward_ios, size: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const Divider(height: 1),

//             // Drawer Items
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.wallet,
//               title: 'Wallet',
//             ),
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.cableCar,
//               title: 'History',
//               onTap: () {
//                 //   Navigator.pop(context);

//                 //   Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(builder: (_) => const HistoryScreen()),
//                 //   );
//               },
//             ),
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.bell,
//               title: 'Notification',
//             ),
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.shieldHalved,
//               title: 'Safety',
//             ),
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.gear,
//               title: 'Settings',
//             ),
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.circleInfo,
//               title: 'Help',
//             ),
//             _drawerItem(
//               context,
//               icon: FontAwesomeIcons.commentDots,
//               title: 'Support',
//             ),

//             const SizedBox(height: 190),

//             // Divider
//             Divider(height: 1, color: Colors.grey[300]),

//             const SizedBox(height: 40),
//             BlocProvider(
//               create: (_) => sl<LogoutBloc>(),
//               child: BlocConsumer<LogoutBloc, LogoutState>(
//                 listener: (context, state) {
//                   if (state is LogoutSuccess) {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (_) => LoginScreen()),
//                       (route) => false,
//                     );
//                   }

//                   if (state is LogoutFailure) {
//                     ScaffoldMessenger.of(
//                       context,
//                     ).showSnackBar(SnackBar(content: Text(state.message)));
//                   }
//                 },
//                 builder: (context, state) {
//                   final isLoading = state is LogoutLoading;

//                   return TextButton(
//                     onPressed: isLoading
//                         ? null
//                         : () {
//                             context.read<LogoutBloc>().add(
//                               const LogoutRequested(),
//                             );
//                           },
//                     child: isLoading
//                         ? const SizedBox(
//                             width: 18,
//                             height: 18,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Text('SignOut'),
//                   );
//                 },
//               ),
//             ),
//            BlocProvider(
//   create: (_) => sl<OnboardingBloc>(),
//   child: BlocConsumer<OnboardingBloc, OnboardingState>(
//     listener: (context, state) {
//       if (state is OnboardingFailure) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(state.message)),
//         );
//       }

//       if (state is OnboardingSuccess) {
//         Navigator.pop(context); // Drawer close

//         final destination =
//             getNextOnboardingDestination(state.status);

//         switch (destination) {
//           case OnboardingDestination.profile:
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => BecomeDriverScreen(),
//               ),
//             );
//             break;

//           case OnboardingDestination.documents:
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => DriverVerificationScreen(),
//               ),
//             );
//             break;

//           case OnboardingDestination.vehicle:
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => VechileDetailScreen(),
//               ),
//             );
//             break;

//           case OnboardingDestination.dashboard:
            
//             break;
//         }
//       }
//     },
//     builder: (context, state) {
//       final isLoading = state is OnboardingLoading;

//       return AuthButton(
//         text: isDriver ? 'Driver Mode' : 'Become a Driver',
//         isLoading: isLoading,
//         onPressed: () {
//           if (isLoading) return;

//           if (isDriver) {
//             context.read<OnboardingBloc>().add(
//               OnboardingStatusRequested(),
//             );
//           } else {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => BecomeDriverScreen(),
//               ),
//             );
//           }
//         },
//       );
//     },
//   ),
// )
//           ],
//         ),
//       ),
//     );
//   }

//   // Reusable Drawer Item
//   Widget _drawerItem(
//     BuildContext context, {
//     required FaIconData icon,
//     required String title,
//     VoidCallback? onTap,
//   }) {
//     return ListTile(
//       dense: true,
//       visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
//       minVerticalPadding: 0,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//       leading: FaIcon(icon, size: 18, color: Colors.grey[700]),
//       title: Text(title, style: const TextStyle(fontSize: 15)),
//       onTap: onTap,
//     );
//   }
// }
