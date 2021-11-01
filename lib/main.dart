import 'package:challenges/courses_platform/ui/courses_home/courses_home_view.dart';
import 'package:challenges/job_search_platform/ui/job_search/job_search_view.dart';
import 'package:challenges/stories_app/ui/home/home_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Challenges'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _ChallengeButton(
              child: HomeView(),
              icon: Icon(Icons.amp_stories),
              label: Text('Stories app'),
            ),
            _ChallengeButton(
              child: JobSearchView(),
              icon: Icon(Icons.cases_rounded),
              label: Text('Job search platform'),
            ),
            _ChallengeButton(
              child: CoursesHomeView(),
              icon: Icon(Icons.play_arrow),
              label: Text('Courses App'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeButton extends StatelessWidget {
  const _ChallengeButton({
    Key? key,
    required this.child,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final Widget child;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => child));
      },
      icon: icon,
      label: label,
    );
  }
}
