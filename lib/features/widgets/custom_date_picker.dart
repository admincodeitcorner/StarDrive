import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';

class CustomDatePickerField extends StatefulWidget {
  const CustomDatePickerField({
    super.key,
    required this.labelText,
    required this.onDateSelected,
    this.hintText = 'YYYY/MM/DD',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.errorText = 'Please select a date',
  });

  final String labelText;
  final String hintText;
  final String errorText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<CustomDatePickerField> createState() =>
      _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late final TextEditingController _controller;
  DateTime? _selected;

  DateTime get _firstDate => widget.firstDate ?? DateTime(1900);

  DateTime get _lastDate => widget.lastDate ?? DateTime.now();

  @override
  void initState() {
    super.initState();

    _selected = widget.initialDate;
    _controller = TextEditingController(
      text: _selected == null ? '' : _format(_selected!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year/$month/$day';
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selected = date;
      _controller.text = _format(date);
    });

    widget.onDateSelected(date);
  }

  // Calendar picker
  Future<void> _pickCalendarDate() async {
    final now = DateTime.now();

    final defaultDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    final initialDate = _selected ?? defaultDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(_firstDate)
          ? _firstDate
          : initialDate.isAfter(_lastDate)
              ? _lastDate
              : initialDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      _selectDate(picked);
    }
  }

  // Custom YYYY/MM/DD input dialog
  Future<void> _enterDateManually() async {
    final dateController = TextEditingController(
      text: _selected == null ? '' : _format(_selected!),
    );

    String? errorText;

    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void validateAndSubmit() {
              final value = dateController.text.trim();

              final match = RegExp(
                r'^(\d{4})/(\d{2})/(\d{2})$',
              ).firstMatch(value);

              if (match == null) {
                setDialogState(() {
                  errorText = 'Enter date as YYYY/MM/DD';
                });
                return;
              }

              final year = int.parse(match.group(1)!);
              final month = int.parse(match.group(2)!);
              final day = int.parse(match.group(3)!);

              final date = DateTime(year, month, day);

              // Reject invalid dates such as 2008/02/31.
              if (date.year != year ||
                  date.month != month ||
                  date.day != day) {
                setDialogState(() {
                  errorText = 'Please enter a valid date';
                });
                return;
              }

              final dateOnly = DateTime(year, month, day);
              final first = DateTime(
                _firstDate.year,
                _firstDate.month,
                _firstDate.day,
              );
              final last = DateTime(
                _lastDate.year,
                _lastDate.month,
                _lastDate.day,
              );

              if (dateOnly.isBefore(first) ||
                  dateOnly.isAfter(last)) {
                setDialogState(() {
                  errorText =
                      'Date must be between ${_format(first)} and ${_format(last)}';
                });
                return;
              }

              Navigator.of(dialogContext).pop(date);
            }

            return AlertDialog(
              title: const Text('Enter date'),
              content: TextField(
                controller: dateController,
                autofocus: true,
                textInputAction: .next,
                keyboardType: TextInputType.datetime,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9/]'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Date of birth',
                  labelStyle: TextStyle(color: AppColors.primary),
                  
                  hintText: 'YYYY/MM/DD',
                  errorText: errorText,
                  counterText: '',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (_) {
                  if (errorText != null) {
                    setDialogState(() {
                      errorText = null;
                    });
                  }
                },
                onSubmitted: (_) => validateAndSubmit(),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel',
                  style: TextStyle(color: AppColors.primary),),
                ),
                TextButton(
                  onPressed: validateAndSubmit,
                  child: Text(
                    'OK',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );



    if (pickedDate != null && mounted) {
      _selectDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthFieldLabel(text: widget.labelText),
          TextFormField(
            controller: _controller,
            readOnly: true,
            onTap: _enterDateManually,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            validator: (value) =>
                value == null || value.isEmpty
                    ? widget.errorText
                    : null,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              suffixIcon: IconButton(
                onPressed: _pickCalendarDate,
                icon: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualDateDialog extends StatefulWidget {
  const _ManualDateDialog({
    required this.initialText,
    required this.firstDate,
    required this.lastDate,
    required this.format,
  });

  final String initialText;
  final DateTime firstDate;
  final DateTime lastDate;
  final String Function(DateTime) format;

  @override
  State<_ManualDateDialog> createState() => _ManualDateDialogState();
}

class _ManualDateDialogState extends State<_ManualDateDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose(); // ab safe hai
    super.dispose();
  }

  void _validateAndSubmit() {
    final value = _controller.text.trim();

    final match = RegExp(r'^(\d{4})/(\d{2})/(\d{2})$').firstMatch(value);
    if (match == null) {
      setState(() => _errorText = 'Enter date as YYYY/MM/DD');
      return;
    }

    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);

    final date = DateTime(year, month, day);

    // Reject invalid dates such as 2008/02/31
    if (date.year != year || date.month != month || date.day != day) {
      setState(() => _errorText = 'Please enter a valid date');
      return;
    }

    final first = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );
    final last = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );

    if (date.isBefore(first) || date.isAfter(last)) {
      setState(() {
        _errorText =
            'Date must be between ${widget.format(first)} and ${widget.format(last)}';
      });
      return;
    }

    Navigator.of(context).pop(date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter date'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.datetime,
        maxLength: 10,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        ],
        decoration: InputDecoration(
          labelText: 'Date of birth',
          hintText: 'YYYY/MM/DD',
          errorText: _errorText,
          counterText: '',
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (_) {
          if (_errorText != null) setState(() => _errorText = null);
        },
        onSubmitted: (_) => _validateAndSubmit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _validateAndSubmit,
          child: Text('OK', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}