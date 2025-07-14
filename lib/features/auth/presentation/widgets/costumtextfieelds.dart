import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final String? Function(String?) validator;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.isPassword = false,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: 270.w,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        cursorColor: color,
        style: TextStyle(fontFamily: 'roboto',color: color),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'roboto',color: color),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
