import 'package:challenges/courses_platform/ui/recomended_detail/widgets/bubble.dart';
import 'package:challenges/courses_platform/ui/recomended_detail/widgets/buy_button.dart';
import 'package:challenges/courses_platform/ui/widgets/animated_size.dart';
import 'package:challenges/courses_platform/ui/widgets/fade_size_transition.dart';
import 'package:challenges/courses_platform/ui/widgets/fade_slide_transition.dart';
import 'package:challenges/courses_platform/ui/widgets/starts.dart';
import 'package:flutter/material.dart';

class RecomendedDetailView extends StatefulWidget {
  const RecomendedDetailView({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  @override
  _RecomendedDetailViewState createState() => _RecomendedDetailViewState();
}

class _RecomendedDetailViewState extends State<RecomendedDetailView> with TickerProviderStateMixin {
  late Animation<double> pageAnimation;
  late AnimationController pageAnimationController;

  late Animation<double> welcomeAnimation;
  late AnimationController welcomeAnimationController;

  String reverseTag = '';

  @override
  void initState() {
    super.initState();
    pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    pageAnimation = Tween<double>(begin: 0, end: 1).animate(pageAnimationController);

    welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    welcomeAnimation = Tween<double>(begin: 0, end: 1).animate(welcomeAnimationController);
    pageAnimation.addStatusListener(_pageAnimationStatusListener);

    pageAnimationController.forward();
  }

  void _pageAnimationStatusListener(AnimationStatus status) {
    if (pageAnimation.isCompleted) welcomeAnimationController.forward();
  }

  @override
  void dispose() {
    pageAnimation.removeStatusListener(_pageAnimationStatusListener);
    pageAnimationController.dispose();

    welcomeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        reverseTag = 'reverse';
        return true;
      },
      child: Scaffold(
        // backgroundColor: Color(0xff151D29),
        backgroundColor: Colors.transparent,
        body: Hero(
          tag: '${widget.tag}$reverseTag',
          child: AnimatedBuilder(
            animation: pageAnimation,
            builder: (context, _) {
              final borderRadius = (1 - (pageAnimation.value)) * 25;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: Color(0xff151D29),
                ),
                padding: const EdgeInsets.only(top: 25),
                child: Material(
                  color: Colors.transparent,
                  child: _Body(
                    pageAnimation: pageAnimation,
                    welcomeAnimation: welcomeAnimation,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.welcomeAnimation,
    required this.pageAnimation,
  }) : super(key: key);

  final Animation<double> welcomeAnimation;
  final Animation<double> pageAnimation;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> with TickerProviderStateMixin {
  late ScrollController scrollController;
  late PageController pageController;
  late TabController tabController;

  late double bubleTopPosition;

  late ScrollPhysics coursesPhysics;

  late ContentStatus contentStatus;

  @override
  void initState() {
    initProperties();

    scrollController = ScrollController();
    scrollController.addListener(scrollControllerListener);

    pageController = PageController();
    pageController.addListener(pageControllerListener);

    tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollControllerListener);
    scrollController.removeListener(pageControllerListener);

    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void initProperties() {
    contentStatus = ContentStatus.expanded;

    bubleTopPosition = 0;

    coursesPhysics = const NeverScrollableScrollPhysics();
  }

  void scrollControllerListener() {
    if (scrollController.offset > 0) {
      coursesPhysics = const ClampingScrollPhysics();
      contentStatus = ContentStatus.scrolling;
    }

    final clamp = scrollController.offset.clamp(0, 600);
    final offsetClamp = (clamp / 600);
    bubleTopPosition = (offsetClamp * 120);

    setState(() {});
  }

  void pageControllerListener() {
    final page = pageController.page!.round();
    tabController.animateTo(page);
  }

  void onVerticalDragUpdate(details) {
    if (details.primaryDelta! > 0) {
      contentStatus = ContentStatus.expanded;
      coursesPhysics = const NeverScrollableScrollPhysics();
    } else {
      contentStatus = ContentStatus.contracted;
      coursesPhysics = const ClampingScrollPhysics();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate:
          contentStatus == ContentStatus.expanded || contentStatus == ContentStatus.contracted
              ? onVerticalDragUpdate
              : null,
      child: Stack(
        children: [
          _Bubbles(
            welcomeAnimation: widget.welcomeAnimation,
            pageAnimation: widget.pageAnimation,
            bubleTopPosition: bubleTopPosition,
          ),
          Column(
            children: [
              FadeSizeTransition(
                fadeAnimation: Tween<double>(begin: 0, end: 1)
                    .animate(CurvedAnimation(parent: widget.pageAnimation, curve: Interval(.9, 1))),
                sizeAnimation: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(parent: widget.pageAnimation, curve: Interval(.3, .7))),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: IconButton(
                      splashRadius: 25,
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      splashRadius: 25,
                      onPressed: () {},
                      hoverColor: Colors.red,
                      icon: ClipOval(
                        child: Image.asset(
                          'lib/courses_platform/assets/user1.jpg',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 350),
                margin: EdgeInsets.only(
                  top: contentStatus == ContentStatus.expanded ? 20 : 0,
                  bottom: 7,
                  left: 24,
                  right: 24,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 350),
                  style: TextStyle(
                    color: Colors.white.withOpacity(.80),
                    fontSize: contentStatus == ContentStatus.expanded ? 27 : 25,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                  ),
                  child: const Text(
                    'Angular - The Complete Guide',
                    maxLines: 2,
                  ),
                ),
              ),
              AnimatedSizeWidget(
                child: Container(
                  margin: EdgeInsets.only(bottom: 7, left: 24, right: 24),
                  child: const Text(
                    'Teaching & Academics',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                duration: 200,
                visible: contentStatus == ContentStatus.expanded,
              ),
              Expanded(
                child: FadeSizeTransition(
                  fadeAnimation: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(parent: widget.welcomeAnimation, curve: Interval(0, .01))),
                  sizeAnimation: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(parent: widget.welcomeAnimation, curve: Interval(0, .01))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSizeWidget(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, left: 24, right: 24),
                          child: Row(
                            children: [
                              FadeSlideTransition(
                                animation: widget.welcomeAnimation,
                                interval: Interval(0, 0.2),
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  icon: Stars(),
                                  label: Text('4.9'),
                                ),
                              ),
                              const Spacer(),
                              FadeSlideTransition(
                                animation: widget.welcomeAnimation,
                                interval: Interval(0.1, 0.3),
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.people_alt,
                                    color: Colors.deepOrangeAccent.withOpacity(.9),
                                    size: 20,
                                  ),
                                  label: Text('30 245'),
                                ),
                              ),
                              const Spacer(),
                              FadeSlideTransition(
                                animation: widget.welcomeAnimation,
                                interval: Interval(0.2, 0.4),
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.access_time_filled,
                                    color: Colors.deepOrangeAccent.withOpacity(.9),
                                    size: 20,
                                  ),
                                  label: Text('86 hrs'),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        duration: 350,
                        visible: contentStatus == ContentStatus.expanded,
                      ),
                      FadeSlideTransition(
                        animation: widget.welcomeAnimation,
                        interval: Interval(0.3, 0.5),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8, left: 24, right: 24),
                          child: Text(
                            '\$19.99',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.80),
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      FadeSlideTransition(
                        animation: widget.welcomeAnimation,
                        interval: Interval(0.4, 0.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSizeWidget(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'About course',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(.90),
                                          letterSpacing: .5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'This course starts from scratch, you neither need to know Angular 1 nor Angular 2! Angular 12 simply is the latest version of Angular that you will love',
                                      style: TextStyle(
                                        height: 1.4,
                                        fontSize: 14,
                                        color: Color(0xff98A0BE),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: .2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    FadeSlideTransition(
                                      animation: widget.welcomeAnimation,
                                      interval: Interval(0.6, 0.7),
                                      child: const Center(
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              duration: 200,
                              visible: contentStatus == ContentStatus.expanded,
                            ),
                            DefaultTabController(
                              length: 2,
                              child: TabBar(
                                controller: tabController,
                                indicator: BoxDecoration(),
                                labelColor: Colors.white,
                                labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                                isScrollable: true,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                unselectedLabelColor: Colors.white54,
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                                tabs: [
                                  const Text('Lessons'),
                                  // const SizedBox(width: 20),
                                  const Text('Reviews'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          children: [
                            NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (overScroll) {
                                overScroll.disallowGlow();

                                if (!overScroll.leading) return true;

                                if (contentStatus == ContentStatus.scrolling) {
                                  contentStatus = ContentStatus.contracted;
                                } else {
                                  contentStatus = ContentStatus.expanded;
                                  coursesPhysics = const NeverScrollableScrollPhysics();
                                }

                                setState(() {});
                                return true;
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                physics: coursesPhysics,
                                controller: scrollController,
                                itemCount: 20,
                                itemBuilder: (context, i) {
                                  return FadeSlideTransition(
                                    animation: widget.welcomeAnimation,
                                    interval: Interval((.6 + (i * .1)).clamp(.6, .8), .8),
                                    beginOffset: Offset(.1, 0),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xff1A243B),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xFF3980C6),
                                              style: BorderStyle.solid,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Color(0xFF3980C6),
                                            size: 30,
                                          ),
                                        ),
                                        title: Text(
                                          'Getting Started $i',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: const Text(
                                          '13 lectures',
                                          style: TextStyle(color: Colors.deepOrangeAccent),
                                        ),
                                        trailing: const Text(
                                          '41 min',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: 10,
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              itemBuilder: (context, i) {
                                final idImage = i % 4 + 2;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: ClipOval(
                                          child: Image.asset(
                                            'lib/courses_platform/assets/user$idImage.jpg',
                                            height: 45,
                                            width: 45,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Manchar Nettem',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        subtitle: Stars(size: 17),
                                        trailing: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                '2 months ago',
                                                style: TextStyle(
                                                  color: Color(0xff98A0BE),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Very good explanations. Giving in depth knowledge of the each topic- He is almost covering all topics in angular official documentation.',
                                        style: TextStyle(
                                          color: Color(0xff98A0BE),
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      FadeSlideTransition(
                        animation: widget.welcomeAnimation,
                        interval: Interval(.9, 1),
                        child: BuyButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Bubbles extends StatelessWidget {
  const _Bubbles({
    Key? key,
    required this.welcomeAnimation,
    required this.pageAnimation,
    required this.bubleTopPosition,
  }) : super(key: key);

  final Animation<double> welcomeAnimation;
  final Animation<double> pageAnimation;
  final double bubleTopPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Bubble(
          animation: welcomeAnimation,
          pageAnimation: pageAnimation,
          size: 50,
          beginTopPosition: MediaQuery.of(context).size.height - 300,
          topPosition: -15 + bubleTopPosition,
          rightPosition: 120,
          beginInterval: 0,
          endInterval: .5,
        ),
        Bubble(
          animation: welcomeAnimation,
          pageAnimation: pageAnimation,
          size: 170,
          beginTopPosition: MediaQuery.of(context).size.height - 220,
          topPosition: bubleTopPosition,
          leftPosition: 8,
          beginInterval: .2,
          endInterval: .9,
        ),
        Bubble(
          animation: welcomeAnimation,
          pageAnimation: pageAnimation,
          size: 70,
          beginTopPosition: MediaQuery.of(context).size.height - 350,
          topPosition: -170 + bubleTopPosition,
          rightPosition: 60,
          beginInterval: .4,
          endInterval: .9,
        ),
      ],
    );
  }
}

enum ContentStatus { contracted, expanded, scrolling }
