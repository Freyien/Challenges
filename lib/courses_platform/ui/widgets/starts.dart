import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  const Stars({Key? key, this.size = 20}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: Colors.deepOrangeAccent.withOpacity(.9),
          size: size,
        ),
      ),
    );
  }
}
