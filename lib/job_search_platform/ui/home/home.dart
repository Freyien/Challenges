import 'dart:ui';

import 'package:challenges/job_search_platform/data/job_cards_data.dart';
import 'package:challenges/job_search_platform/models/job_card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobSearchPlatformHomeView extends StatelessWidget {
  const JobSearchPlatformHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Color(0xffDCDEE9),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth * .70;
          final cardHeight = 200;
          final maxVerticalScroll = 125.0;

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
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  'Product Designer Vacancies',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    wordSpacing: constraints.maxWidth,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'We found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '260',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Results',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.orangeAccent,
                            size: 50,
                          ),
                          Text(
                            'San Fracisco',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, maxVerticalScroll),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                    return true;
                  },
                  child: ListView.custom(
                    padding: EdgeInsets.only(
                      left: cardWidth * .4,
                      top: constraints.maxHeight - cardHeight - maxVerticalScroll,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (_, index) {
                        return _JobCard(
                          cardWidth: cardWidth,
                          jobCard: jobCardsData[index],
                          maxVerticalScroll: maxVerticalScroll,
                        );
                      },
                      childCount: jobCardsData.length,
                    ),
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _JobCard extends StatefulWidget {
  const _JobCard({
    Key? key,
    required this.cardWidth,
    required this.jobCard,
    required this.maxVerticalScroll,
  }) : super(key: key);

  final double cardWidth;
  final JobCardModel jobCard;
  final double maxVerticalScroll;

  @override
  __JobCardState createState() => __JobCardState();
}

class __JobCardState extends State<_JobCard> {
  late double dy;
  late double initialPosition;
  late CardState cardState;

  @override
  void initState() {
    super.initState();
    cardState = CardState.initial;
    dy = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      widthFactor: .50,
      child: Transform.translate(
        offset: Offset(0, -dy),
        child: Container(
          width: widget.cardWidth,
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) async {
              setState(() {
                dy = (initialPosition - details.globalPosition.dy)
                    .clamp(0, widget.maxVerticalScroll);
              });
              if (dy == widget.maxVerticalScroll) {
                cardState = CardState.expanding;
                await Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 950),
                    reverseTransitionDuration: Duration(milliseconds: 950),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return _BlackView(
                        jobCard: widget.jobCard,
                        animation: animation,
                      );
                    },
                  ),
                );
                setState(() {
                  dy = 0;
                  cardState = CardState.initial;
                });
              }
            },
            onVerticalDragStart: (details) {
              setState(() {
                initialPosition = details.globalPosition.dy;
                cardState = CardState.draging;
              });
            },
            onVerticalDragEnd: (details) {
              setState(() {
                if (cardState != CardState.expanding) {
                  dy = 0;
                }
              });
            },
            child: Hero(
              tag: 'job-${widget.jobCard.id}',
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                if (flightDirection == HeroFlightDirection.push) {
                  return DefaultTextStyle(
                    style: DefaultTextStyle.of(toHeroContext).style,
                    child: toHeroContext.widget,
                  );
                } else {
                  return DefaultTextStyle(
                    style: DefaultTextStyle.of(toHeroContext).style,
                    child: fromHeroContext.widget,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  color: Colors.black,
                ),
                child: _JobCardContent(
                  jobCard: widget.jobCard,
                  map: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JobCardContent extends StatelessWidget {
  const _JobCardContent({
    Key? key,
    required this.jobCard,
    required this.map,
    this.imageSize = 20,
    this.jobPositionSize = 18,
  }) : super(key: key);

  final JobCardModel jobCard;
  final Widget map;
  final double imageSize;
  final double jobPositionSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.withOpacity(.15),
                    child: Image.asset(
                      'lib/job_search_platform/assets/${jobCard.id}.png',
                      height: imageSize,
                      width: imageSize,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  jobCard.company,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  jobCard.position,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.85),
                    fontWeight: FontWeight.bold,
                    fontSize: jobPositionSize,
                    wordSpacing: 1000,
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                    children: [
                      TextSpan(
                        text: '\$${jobCard.salary}k',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.85),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '/${jobCard.salaryFrecuency}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(color: Colors.transparent, child: map),
        )
      ],
    );
  }
}

class _BlackView extends StatefulWidget {
  const _BlackView({Key? key, required this.jobCard, required this.animation}) : super(key: key);

  final JobCardModel jobCard;
  final Animation<double> animation;

  @override
  __BlackViewState createState() => __BlackViewState();
}

class __BlackViewState extends State<_BlackView> with SingleTickerProviderStateMixin {
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
                    child: _JobCardContent(
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

enum CardState { initial, draging, expanding }
