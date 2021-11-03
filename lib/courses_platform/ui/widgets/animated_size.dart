import 'package:challenges/courses_platform/ui/widgets/fade_size_transition.dart';
import 'package:flutter/material.dart';

class AnimatedSizeWidget extends StatelessWidget {
  const AnimatedSizeWidget({
    Key? key,
    required this.visible,
    required this.child,
    required this.duration,
  }) : super(key: key);

  final bool visible;
  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      transitionBuilder: (child, animation) {
        return FadeSizeTransition(
          fadeAnimation: animation,
          sizeAnimation: animation,
          child: child,
        );
      },
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}
