import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/api_colors.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';

/// Passenger / Driver segmented toggle (dropdown ki jagah).
class AuthRoleSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String label;

  const AuthRoleSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Register as',
  });

  static const _options = [
    _RoleOption('Passenger', Icons.person_outline_rounded),
    _RoleOption('Driver', Icons.directions_car_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthFieldLabel(text: label),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: _options
                  .map(
                    (o) => Expanded(
                      child: _Segment(
                        option: o,
                        selected: o.label == value,
                        onTap: () => onChanged(o.label),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleOption {
  final String label;
  final IconData icon;
  const _RoleOption(this.label, this.icon);
}

class _Segment extends StatelessWidget {
  final _RoleOption option;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primary.withOpacity(0.4)
                : Colors.transparent,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option.icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}