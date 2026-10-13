import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.passwordIconVisibility=false,
    this.obscureText = false,
    this.validator, required this.labelText,
  });

  final TextEditingController controller;
  
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool passwordIconVisibility ;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return '$hintText is required';
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: passwordIconVisibility ? Icon(Icons.visibility): null,
          
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}