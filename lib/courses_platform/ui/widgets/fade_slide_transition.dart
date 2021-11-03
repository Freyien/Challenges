import 'package:flutter/material.dart';

class FadeSlideTransition extends StatelessWidget {
  const FadeSlideTransition({
    Key? key,
    required this.animation,
    required this.interval,
    required this.child,
    this.beginOffset = const Offset(0, .1),
    this.endOffset = const Offset(0, 0),
    this.beginOpacity = 0,
    this.endOpacity = 1,
  }) : super(key: key);

  final Offset beginOffset;
  final Offset endOffset;
  final Animation<double> animation;
  final Interval interval;
  final Widget child;
  final double beginOpacity;
  final double endOpacity;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: beginOpacity, end: endOpacity)
          .animate(CurvedAnimation(parent: animation, curve: interval)),
      child: SlideTransition(
        position: Tween<Offset>(begin: beginOffset, end: endOffset)
            .animate(CurvedAnimation(parent: animation, curve: interval)),
        child: child,
      ),
    );
  }
}
