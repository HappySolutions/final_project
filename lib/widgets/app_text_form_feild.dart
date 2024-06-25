// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormFeild extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  const AppTextFormFeild(
      {this.labelText,
      this.controller,
      this.keyboardType,
      this.inputFormatters,
      this.onChanged,
      this.validator,
      super.key});

  InputBorder get textFieldBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: textFieldBorder,
        focusedBorder: textFieldBorder.copyWith(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: textFieldBorder,
        errorBorder: textFieldBorder.copyWith(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        labelText: labelText,
      ),
    );
  }
}
