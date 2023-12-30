import 'package:flutter/material.dart';
import 'package:my_laundry/config/app_assets.dart';

class ErrorBackground extends StatelessWidget {
  const ErrorBackground(
      {super.key, required this.ratio, required this.message});
  final double ratio;
  final String message;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(fit: StackFit.expand, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            AppAssets.emptyBg,
            fit: BoxFit.cover,
          ),
        ),
        UnconstrainedBox(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(message)),
        )
      ]),
    );
  }
}
