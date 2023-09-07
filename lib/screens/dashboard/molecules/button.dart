import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.isOnline,
    this.onTap,
    this.widget,
  });

  final bool isOnline;
  final VoidCallback? onTap;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isOnline ? onTap : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.blue.shade100;
              }
              return Colors.blue.shade400;
            },
          ),
          fixedSize: MaterialStateProperty.all<Size>(
            const Size(double.maxFinite, 45),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        child: widget,
      ),
    );
  }
}
