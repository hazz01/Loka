import 'package:flutter/material.dart';

class TextFieldWithHeader extends StatefulWidget {
  final String headerTitle;
  final String placeholder;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const TextFieldWithHeader({
    super.key,
    required this.headerTitle,
    required this.placeholder,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  State<TextFieldWithHeader> createState() => _TextFieldWithHeaderState();
}

class _TextFieldWithHeaderState extends State<TextFieldWithHeader> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Title
        Text(
          widget.headerTitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xff212121),
          ),
        ),
        const SizedBox(height: 8),

        // Text Field
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xff212121),
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff757575),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 21,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            // Password visibility toggle
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xff757575),
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
