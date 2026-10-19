import 'package:flutter/material.dart';
import 'package:star_drive/features/auth/presentation/screens/driver_signup_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/passanger_signup_screen.dart';
// import PassengerSignUpScreen / DriverSignUpScreen

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Are you a passenger or a driver?',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'You can change the mode later',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ),
                      const Spacer(),
                      _RoleButton(
                        label: 'Passenger',
                        background: scheme.primary,
                        foreground: scheme.onPrimary,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PassengerSignUpScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _RoleButton(
                        label: 'Driver',
                        background: scheme.surfaceContainerHighest,
                        foreground: scheme.onSurface,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverSignUpScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
        child: Text(label),
      ),
    );
  }
}