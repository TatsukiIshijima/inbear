import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String labelText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final String Function(String) validator;
  final void Function(String) onFieldSubmitted;
  final void Function(String) onChanged;

  InputField({
    @required
    this.labelText,
    @required
    this.textEditingController,
    this.obscureText = false,
    this.textInputType,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText
      ),
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: obscureText,
      focusNode: focusNode,
      validator: (text) => validator(text),
      onFieldSubmitted: (text) => onFieldSubmitted(text),
      onChanged: (text) => onChanged(text),
    );
  }

}