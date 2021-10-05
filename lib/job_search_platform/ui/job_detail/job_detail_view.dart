import 'dart:ui';

import 'package:challenges/job_search_platform/models/job_card_model.dart';
import 'package:challenges/job_search_platform/ui/widgets/job_card_content.dart';
import 'package:flutter/material.dart';

class JobDetailView extends StatefulWidget {
  const JobDetailView({Key? key, required this.jobCard, required this.animation}) : super(key: key);

  final JobCardModel jobCard;
  final Animation<double> animation;

  @override
  _JobDetailViewState createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> with SingleTickerProviderStateMixin {
  late Animation<double> tweenFromEighty;
  late Animation<double> tweenFromZero;

  @override
  void initState() {
    super.initState();

    print('init state');
    tweenFromEighty = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: widget.animation,
      curve: Interval(.80, 1),
    ));

    tweenFromZero = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: widget.animation,
      curve: Interval(0, 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: 'job-${widget.jobCard.id}',
        child: LayoutBuilder(
          builder: (context, constraints) {
            print('init state: ${tweenFromEighty.value}');
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;

            final mapDx = (1 - tweenFromEighty.value) * width / 2;
            final detailsContentDy = (1 - tweenFromEighty.value) * 50;
            final detailsContentOpacity = tweenFromEighty.value;

            final cardBorder = (1 - tweenFromZero.value) * 35;
            final jobImageSize = (1 + tweenFromZero.value) * 20;
            final jobPositionSize = (1 + tweenFromZero.value) * 18 - (tweenFromZero.value * 8);
            final topHeight = tweenFromZero.value * 20;

            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(cardBorder),
                  topRight: Radius.circular(cardBorder),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xff0D0B20), Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                children: [
                  SizedBox(height: topHeight),
                  Container(
                    height: height * .5 + 10,
                    child: JobCardContent(
                      jobCard: widget.jobCard,
                      imageSize: (jobImageSize),
                      jobPositionSize: jobPositionSize,
                      map: ClipRRect(
                        child: Transform.translate(
                          offset: Offset(mapDx, 0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                ),
                                child: Image.asset(
                                  'lib/job_search_platform/assets/map1.png',
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on_sharp,
                                      color: Colors.orangeAccent,
                                      size: 35,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Transform.translate(
                      offset: Offset(0, detailsContentDy),
                      child: Opacity(
                        opacity: detailsContentOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, -30),
                              child: Row(
                                children: [
                                  _BlurButton(
                                    text: 'Full-time',
                                    icon: Icon(Icons.access_time),
                                  ),
                                  _BlurButton(
                                    title: '620',
                                    text: 'Submitted',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _Requirement(title: '5+ years', subtitle: 'Experience of Design'),
                                _Requirement(title: 'Bachelor\'s', subtitle: 'Degree'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Image.asset('lib/job_search_platform/assets/user1.jpg'),
                                title: const Text(
                                  'Emily Hughes',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: const Text(
                                  'Recluter',
                                  style: TextStyle(color: Colors.white60),
                                ),
                                trailing: ClipOval(
                                  child: Container(
                                    color: Colors.white,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.message_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
                              style: TextStyle(color: Colors.white60),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white60,
            ),
          )
        ],
      ),
    );
  }
}

class _BlurButton extends StatelessWidget {
  const _BlurButton({Key? key, required this.text, this.icon, this.title}) : super(key: key);

  final String text;
  final Icon? icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  const Icon(
                    Icons.access_time,
                    color: Colors.white70,
                    size: 26,
                  ),
                if (title != null)
                  Text(
                    title!,
                    style:
                        TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
