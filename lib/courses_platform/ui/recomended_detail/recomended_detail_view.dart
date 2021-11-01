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

class __BodyState extends State<_Body> {
  late ScrollController scrollController;

  late double bubleTopPosition;

  late ScrollPhysics coursesPhysics;

  late ContentStatus contentStatus;

  @override
  void initState() {
    initProperties();

    scrollController = ScrollController();
    scrollController.addListener(scrollControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollControllerListener);
    scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate:
          contentStatus == ContentStatus.expanded || contentStatus == ContentStatus.contracted
              ? (details) {
                  if (details.primaryDelta! > 0) {
                    contentStatus = ContentStatus.expanded;
                    coursesPhysics = const NeverScrollableScrollPhysics();
                  } else {
                    contentStatus = ContentStatus.contracted;
                    coursesPhysics = const ClampingScrollPhysics();
                  }

                  setState(() {});
                }
              : null,
      child: Stack(
        children: [
          _Bubble(
            animation: widget.welcomeAnimation,
            pageAnimation: widget.pageAnimation,
            size: 50,
            beginTopPosition: MediaQuery.of(context).size.height - 300,
            topPosition: -15 + bubleTopPosition,
            rightPosition: 120,
            beginInterval: 0,
            endInterval: .5,
          ),
          _Bubble(
            animation: widget.welcomeAnimation,
            pageAnimation: widget.pageAnimation,
            size: 170,
            beginTopPosition: MediaQuery.of(context).size.height - 220,
            topPosition: bubleTopPosition,
            leftPosition: 8,
            beginInterval: .2,
            endInterval: .9,
          ),
          _Bubble(
            animation: widget.welcomeAnimation,
            pageAnimation: widget.pageAnimation,
            size: 70,
            beginTopPosition: MediaQuery.of(context).size.height - 350,
            topPosition: -170 + bubleTopPosition,
            rightPosition: 60,
            beginInterval: .4,
            endInterval: .9,
          ),
          Column(
            children: [
              _FadeSizeTransition(
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
                child: _FadeSizeTransition(
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
                              _FadeSlideTransition(
                                animation: widget.welcomeAnimation,
                                interval: Interval(0, 0.2),
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  icon: _Stars(),
                                  label: Text('4.9'),
                                ),
                              ),
                              const Spacer(),
                              _FadeSlideTransition(
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
                              _FadeSlideTransition(
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
                      _FadeSlideTransition(
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
                      _FadeSlideTransition(
                        animation: widget.welcomeAnimation,
                        interval: Interval(0.4, 0.6),
                        child: Column(
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
                                    _FadeSlideTransition(
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
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text('Lessons'),
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onSurface: Colors.white70,
                                    ),
                                    onPressed: null,
                                    child: const Text('Reviews'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
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
                                  return _FadeSlideTransition(
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
                                        subtitle: _Stars(size: 17),
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
                      _FadeSlideTransition(
                        animation: widget.welcomeAnimation,
                        interval: Interval(.9, 1),
                        child: _BuyButton(),
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

class _Bubble extends StatefulWidget {
  const _Bubble({
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
  __BubbleState createState() => __BubbleState();
}

class __BubbleState extends State<_Bubble> {
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

class _Stars extends StatelessWidget {
  const _Stars({Key? key, this.size = 20}) : super(key: key);

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

class AnimatedSizeWidget extends StatelessWidget {
  const AnimatedSizeWidget({
    Key? key,
    required this.visible,
    required this.child,
    required this.duration,
  }) : super(key: key);

  final bool visible;
  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      transitionBuilder: (child, animation) {
        return _FadeSizeTransition(
          fadeAnimation: animation,
          sizeAnimation: animation,
          child: child,
        );
      },
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}

class _FadeSizeTransition extends StatelessWidget {
  const _FadeSizeTransition({
    Key? key,
    required this.fadeAnimation,
    required this.sizeAnimation,
    required this.child,
  }) : super(key: key);

  final Animation<double> fadeAnimation;
  final Animation<double> sizeAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizeTransition(
        sizeFactor: sizeAnimation,
        child: child,
      ),
    );
  }
}

class _FadeSlideTransition extends StatelessWidget {
  const _FadeSlideTransition({
    Key? key,
    required this.animation,
    required this.interval,
    required this.child,
    this.beginOffset = const Offset(0, .1),
  }) : super(key: key);

  final Offset beginOffset;
  final Animation<double> animation;
  final Interval interval;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1)
          .animate(CurvedAnimation(parent: animation, curve: interval)),
      child: SlideTransition(
        position: Tween<Offset>(begin: beginOffset, end: Offset(0, 0))
            .animate(CurvedAnimation(parent: animation, curve: interval)),
        child: child,
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12, top: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          primary: Colors.deepOrangeAccent.withOpacity(.9),
        ),
        onPressed: () {},
        child: const Text('Buy now'),
      ),
    );
  }
}

enum ContentStatus { contracted, expanded, scrolling }
