import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/job_search_platform/assets/map.png',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(.0),
                Colors.white,
              ],
              focalRadius: .3,
              center: Alignment.centerRight,
              focal: Alignment.centerRight,
              radius: .7,
            ),
          ),
        ),
      ],
    );
  }
}
