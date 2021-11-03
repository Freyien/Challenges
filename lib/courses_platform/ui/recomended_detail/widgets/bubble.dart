import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  const Bubble({
    Key? key,
    required this.animation,
    required this.pageAnimation,
    required this.size,
    required this.beginTopPosition,
    required this.topPosition,
    this.rightPosition,
    this.leftPosition,
    required this.beginInterval,
    required this.endInterval,
  }) : super(key: key);

  final Animation<double> animation;
  final Animation<double> pageAnimation;
  final double size;
  final double beginTopPosition;
  final double topPosition;
  final double? rightPosition;
  final double? leftPosition;
  final double beginInterval;
  final double endInterval;

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  late Animation<double> welcomeAnimation;

  @override
  void initState() {
    welcomeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: widget.animation,
      curve: Interval(
        widget.beginInterval,
        widget.endInterval,
        curve: Curves.easeInOutQuad,
      ),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: welcomeAnimation,
      builder: (context, _) {
        return Positioned(
          top: widget.beginTopPosition -
              (welcomeAnimation.value * widget.beginTopPosition) -
              widget.topPosition,
          left: widget.leftPosition,
          right: widget.rightPosition,
          child: ClipOval(
            child: Container(
              height: widget.size,
              width: widget.size,
              color: Color(0xff1E2338),
            ),
          ),
        );
      },
    );
  }
}
