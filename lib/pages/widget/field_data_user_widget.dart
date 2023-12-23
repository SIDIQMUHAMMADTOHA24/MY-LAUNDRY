import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';

class FieldDataUserWidget extends StatelessWidget {
  const FieldDataUserWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final String hint;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
                child: icon),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: hint == 'Password'
                ? DInputPassword(
                    contentPadding: const EdgeInsets.all(19),
                    controller: controller,
                    radius: BorderRadius.circular(10),
                    fillColor: Colors.white70,
                    hint: hint,
                  )
                : DInput(
                    contentPadding: const EdgeInsets.all(19),
                    controller: controller,
                    fillColor: Colors.white70,
                    hint: hint,
                    radius: BorderRadius.circular(10),
                  ),
          )
        ],
      ),
    );
  }
}
