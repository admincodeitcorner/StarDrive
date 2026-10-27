// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.validator,
    this.textInputAction
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputAction? textInputAction ;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isHidden = true;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(text: widget.labelText),
        TextFormField(
          controller: widget.controller,
          textInputAction: widget.textInputAction ,

          obscureText: _isHidden,
          style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textHint,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _isHidden = !_isHidden),
              icon: Icon(
                _isHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textHint,
              ),
            ),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary),
            errorBorder: _border(Colors.red),
            focusedErrorBorder: _border(Colors.red),
          ),
        ),
      ],
    );
  }
}
// class PasswordTextField extends StatefulWidget {
//   const PasswordTextField({
//     super.key,
//     required this.controller,
//     this.labelText = 'Password',
//     this.hintText = 'Enter password',
//     this.validator,
//   });

//   final TextEditingController controller;
//   final String labelText;
//   final String hintText;
//   final String? Function(String?)? validator;

//   @override
//   State<PasswordTextField> createState() =>
//       _PasswordTextFieldState();
// }

// class _PasswordTextFieldState extends State<PasswordTextField> {
//   bool isPasswordHidden = true;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: TextFormField(
//         controller: widget.controller,
//         obscureText: isPasswordHidden,
//         validator: widget.validator ??
//             (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return '${widget.hintText} is required';
//               }
//               return null;
//             },
//         decoration: InputDecoration(
//           labelText: widget.labelText,
//           hintText: widget.hintText,
//           border: const OutlineInputBorder(),
//           suffixIcon: IconButton(
//             onPressed: () {
//               setState(() {
//                 isPasswordHidden = !isPasswordHidden;
//               });
//             },
//             icon: Icon(
//               isPasswordHidden
//                   ? Icons.visibility_off
//                   : Icons.visibility,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
