import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final String? errorText;
  final bool obscureText;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const TextFieldWidget({
    super.key,
    this.controller,
    required this.text,
    required this.obscureText,
    this.suffixIcon,
    this.keyboardType, this.errorText, this.onChanged,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      textCapitalization: TextCapitalization.words,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        errorText: widget.errorText,
        suffixIcon: widget.suffixIcon,
        hintText: widget.text,
        hintStyle: const TextStyle(color: Color(0xFF9296A6)),
        filled: true,
        fillColor:  Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 18.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 1.5,
            color: Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}
