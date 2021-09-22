import 'package:flutter/material.dart';

class ExpandedCard extends StatelessWidget {
  const ExpandedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Freyien',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This was my first challenge',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.white30,
            ),
            onPressed: () {},
            icon: Icon(Icons.code),
            label: Text('Follow me on GitHub'),
          )
        ],
      ),
    );
  }
}
