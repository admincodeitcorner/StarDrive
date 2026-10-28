import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/dashboard/domain/entities/user_profile.dart';
import 'package:star_drive/features/dashboard/presentation/bloc/user_profile_bloc.dart';
import 'package:star_drive/features/dashboard/presentation/bloc/user_profile_event.dart';
import 'package:star_drive/features/dashboard/presentation/bloc/user_profile_state.dart';
import 'package:star_drive/features/dashboard/presentation/screens/widgets/edit_phone_dialog.dart';
import 'package:star_drive/features/dashboard/presentation/screens/widgets/phome_otp_dialog.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserProfileBloc>()..add(const UserProfileRequested()),
      child: const _ProfileSettingView(),
    );
  }
}

class _ProfileSettingView extends StatelessWidget {
  const _ProfileSettingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(centerTitle: true, title: const Text('Profile Setting')),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        buildWhen: (previous, current) {
          return current is UserProfileInitial ||
              current is UserProfileLoading ||
              current is UserProfileLoaded ||
              current is UserProfileFailure;
        },
        builder: (context, state) {
          if (state is UserProfileLoading || state is UserProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<UserProfileBloc>().add(
                          const UserProfileRequested(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is UserProfileLoaded) {
            return _ProfileDetails(profile: state.userProfile);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileDetails extends StatefulWidget {
  const _ProfileDetails({required this.profile});

  final UserProfile profile;

  @override
  State<_ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<_ProfileDetails> {
  late String _completePhoneNumber;

  @override
  void initState() {
    super.initState();

    // Backend se milne wale number ko complete format mein rakho.
    _completePhoneNumber = _toCompletePhoneNumber(widget.profile.contactNumber);
  }

  @override
  void didUpdateWidget(covariant _ProfileDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Profile dobara load hone par updated number refresh karo.
    if (oldWidget.profile.contactNumber != widget.profile.contactNumber) {
      _completePhoneNumber = _toCompletePhoneNumber(
        widget.profile.contactNumber,
      );
    }
  }

  // Number ko Login screen jaisi +92 format mein convert karta hai.
  String _toCompletePhoneNumber(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');

    if (digits.startsWith('0092')) {
      digits = digits.substring(4);
    } else if (digits.startsWith('92') && digits.length > 10) {
      digits = digits.substring(2);
    }

    if (digits.startsWith('0') && digits.length == 11) {
      digits = digits.substring(1);
    }

    if (digits.length == 10 && digits.startsWith('3')) {
      return '+92$digits';
    }

    return input.trim();
  }

  // Basic Pakistani mobile number format validation.
  bool _isValidCompletePhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');

    return digits.length == 12 &&
        digits.startsWith('92') &&
        digits.substring(2).startsWith('3');
  }

  Future<void> _showEditPhoneDialog() async {
    final updatedNumber = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditPhoneDialog(initialPhoneNumber: _completePhoneNumber),
    );

    if (!mounted || updatedNumber == null) {
      return;
    }

    setState(() {
      // Dialog se return hone wale number ko complete format mein rakho.
      _completePhoneNumber = _toCompletePhoneNumber(updatedNumber);
    });
  }

  void _startPhoneUpdate() {
    final phoneNumber = _completePhoneNumber.trim();

    if (!_isValidCompletePhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Pakistani mobile number.'),
        ),
      );
      return;
    }

    // Complete number OTP send event mein pass hoga.
    context.read<UserProfileBloc>().add(
      PhoneOtpSendRequested(contactNumber: phoneNumber),
    );
  }

  Future<void> _handleOtpSent(BuildContext context) async {
    final phoneNumber = _completePhoneNumber.trim();

    if (!_isValidCompletePhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Pakistani mobile number.'),
        ),
      );
      return;
    }

    final otp = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PhoneOtpDialog(phoneNumber: phoneNumber),
    );

    if (!mounted || otp == null || otp.trim().isEmpty) {
      return;
    }

    // OTP aur complete phone number BLoC ko pass karo.
    context.read<UserProfileBloc>().add(
      PhoneNumberUpdateRequested(
        contactNumber: phoneNumber,
        otpCode: otp.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    final dateOfBirth = profile.dob == null
        ? 'Not provided'
        : profile.dob!.toLocal().toString().split(' ').first;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is PhoneOtpSent) {
          _handleOtpSent(context);
        } else if (state is PhoneOtpSendFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is PhoneNumberUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number updated successfully!')),
          );
        } else if (state is PhoneNumberUpdateFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                _ProfileAvatar(imageUrl: profile.profilePicPath),
                const SizedBox(height: 12),
                Text(
                  profile.name.isEmpty ? 'User' : profile.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(profile.role.isEmpty ? 'Role not provided' : profile.role),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                'Contact Number',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              subtitle: Text(
                _completePhoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primary),
                onPressed: _showEditPhoneDialog,
              ),
            ),
          ),

          _Section(
            title: 'Personal information',
            items: [
              _ProfileItem('User ID', profile.id.toString()),
              _ProfileItem('Name', profile.name),
              _ProfileItem('Father name', profile.fatherName),
              _ProfileItem('CNIC', profile.cnic),
              _ProfileItem('Address', profile.address),
              _ProfileItem('Date of birth', dateOfBirth),
            ],
          ),

          const SizedBox(height: 15),

          _Section(
            title: 'Account information',
            items: [
              _ProfileItem('Role', profile.role),
              _ProfileItem(
                'Account status',
                profile.isActive ? 'Active' : 'Inactive',
              ),
              _ProfileItem('Driver account', profile.isDriver ? 'Yes' : 'No'),
              _ProfileItem(
                'Passenger rating',
                profile.passengerRating.toString(),
              ),
            ],
          ),

          const SizedBox(height: 15),

          AuthButton(
            text: 'Update Data',
            isLoading: false,
            onPressed: _startPhoneUpdate,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';

    if (url.isEmpty) {
      return const CircleAvatar(
        radius: 54,
        child: Icon(Icons.person, size: 58),
      );
    }

    return ClipOval(
      child: Image.network(
        url,
        width: 108,
        height: 108,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const CircleAvatar(
            radius: 54,
            child: Icon(Icons.person, size: 58),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<_ProfileItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (int i = 0; i < items.length; i++) ...[
              _InfoRow(label: items[i].label, value: items[i].value),
              if (i != items.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileItem {
  const _ProfileItem(this.label, this.value);

  final String label;
  final String value;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? 'Not provided' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(displayValue, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
