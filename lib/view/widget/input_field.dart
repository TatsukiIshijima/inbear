import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final bool obscureText;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final String Function(String) validator;
  final Function(String) onFieldSubmitted;
  final Function(String) onChanged;
  final bool isPasswordInput;
  final bool isVisiblePassword;
  final Function() onChangeVisible;

  InputField(this.labelText, this.textEditingController,
      {this.hintText = '',
      this.maxLines = 1,
      this.maxLength = 20,
      this.obscureText = false,
      this.textInputType = TextInputType.text,
      this.focusNode,
      this.validator,
      this.onFieldSubmitted,
      this.onChanged,
      this.isPasswordInput = false,
      this.isVisiblePassword = false,
      this.onChangeVisible});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
          counterText: '',
          suffixIcon: isPasswordInput
              ? IconButton(
                  icon: isVisiblePassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onPressed:
                      onChangeVisible != null ? () => onChangeVisible() : null,
                )
              : null),
      controller: textEditingController,
      maxLines: maxLines,
      maxLength: maxLength,
      maxLengthEnforced: true,
      keyboardType: textInputType,
      obscureText: obscureText,
      focusNode: focusNode,
      validator: (text) => validator(text),
      onFieldSubmitted: (text) => onFieldSubmitted(text),
      onChanged: (text) => onChanged(text),
    );
  }
}
