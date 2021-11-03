import 'package:flutter/material.dart';

class FadeSizeTransition extends StatelessWidget {
  const FadeSizeTransition({
    Key? key,
    required this.fadeAnimation,
    required this.sizeAnimation,
    required this.child,
  }) : super(key: key);

  final Animation<double> fadeAnimation;
  final Animation<double> sizeAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizeTransition(
        sizeFactor: sizeAnimation,
        child: child,
      ),
    );
  }
}
