// import 'package:flutter/material.dart';
// import 'package:star_drive/core/constant/app_colors.dart';
// import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';

// class CustomDatePickerField extends StatefulWidget {
//   const CustomDatePickerField({
//     super.key,
//     required this.labelText,
//     required this.onDateSelected,
//     this.hintText = 'YYYY/MM/DD',
//     this.initialDate,
//     this.firstDate,
//     this.lastDate,
//     this.errorText = 'Please select a date',
//   });

//   final String labelText;
//   final String hintText;
//   final String errorText;
//   final DateTime? initialDate;
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//   final ValueChanged<DateTime> onDateSelected;

//   @override
//   State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
// }

// class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
//   late final TextEditingController _controller;
//   DateTime? _selected;

//   @override
//   void initState() {
//     super.initState();
//     _selected = widget.initialDate;
//     _controller = TextEditingController(
//       text: _selected == null ? '' : _format(_selected!),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   String _two(int n) => n.toString().padLeft(2, '0');

//   String _format(DateTime d) =>
//       '${d.year.toString().padLeft(4, '0')} / ${_two(d.month)} /${_two(d.day)}';

//   Future<void> _pickDate() async {
//     final now = DateTime.now();

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selected ?? DateTime(now.year - 18, now.month, now.day),
//       firstDate: widget.firstDate ?? DateTime(1900),
//       lastDate: widget.lastDate ?? now,
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: Theme.of(
//             context,
//           ).colorScheme.copyWith(primary: AppColors.primary),
//         ),
//         child: child!,
//       ),
//     );

//     if (picked != null && mounted) {
//       setState(() {
//         _selected = picked;
//         _controller.text = _format(picked);
//       });
//       widget.onDateSelected(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AuthFieldLabel(text: widget.labelText),
//           TextFormField(
//             controller: _controller,
//             readOnly: true,
//             onTap: _pickDate,
//             style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
//             validator: (value) =>
//                 (value == null || value.isEmpty) ? widget.errorText : null,
//             decoration: InputDecoration(
//               hintText: widget.hintText,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 18,
//               ),
//               suffixIcon: IconButton(
//                 onPressed: _pickDate,
//                 icon: const Icon(
//                   Icons.calendar_month_outlined,
//                   color: AppColors.textHint,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
