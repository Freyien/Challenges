import 'package:flutter/material.dart';

class JobName extends StatelessWidget {
  const JobName({Key? key, required this.jobName}) : super(key: key);

  final String jobName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 32),
      child: Text(
        jobName,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          wordSpacing: double.infinity,
        ),
      ),
    );
  }
}
