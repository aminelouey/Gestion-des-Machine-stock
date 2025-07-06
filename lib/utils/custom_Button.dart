import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    this.title,
    this.titleWidget,
    this.onPressed,
  }) : assert(title != null || titleWidget != null,
            'Either title or titleWidget must be provided');

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        backgroundColor:  Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: widget.titleWidget ?? Text(
        widget.title!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
