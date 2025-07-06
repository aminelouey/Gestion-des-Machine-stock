import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final IconData icondata;
  final String hinText;
  final String? Function(String?)? validator;

  const CustomTextfield({
    super.key,
    required this.icondata,
    required this.hinText,
    this.controller,
    this.validator,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.hinText == 'Password' ? obscureText : false,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            widget.icondata,
            color: Colors.grey.shade400,
            size: 25,
          ),
        ),
        hintText: widget.hinText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 16,
        ),
        suffixIcon: widget.hinText == 'Password'
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade100,
            width: 1.0,
          ),
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 16,
        ),
      ),
    );
  }
}
