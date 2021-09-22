import 'package:challenges/stories_app/data/cards_data.dart';
import 'package:challenges/stories_app/ui/home/widgets/expanded_card.dart';
import 'package:challenges/stories_app/ui/home/widgets/story_card.dart';
import 'package:challenges/stories_app/ui/home/widgets/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final initialPage = 1.0;
  final viewportFraction = 0.85;

  late PageController pageController;
  late double currentPageClamp;
  late double currentPage;

  late ScrollController scrollController;
  GlobalKey bankCardKey = GlobalKey();
  double initialDy = 0;
  double dy = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getBackgroundCardInitialPosition();
    });

    // Instance Controllers
    scrollController = ScrollController();
    pageController = PageController(
      initialPage: initialPage.toInt(),
      viewportFraction: viewportFraction,
    );

    // Add Listeners
    pageController.addListener(pageControllerListener);
    scrollController.addListener(scrollControllerListener);

    // Initial values
    currentPage = initialPage;
    currentPageClamp = initialPage;
  }

  @override
  void dispose() {
    pageController.removeListener(pageControllerListener);
    scrollController.removeListener(scrollControllerListener);

    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  pageControllerListener() {
    setState(() {
      currentPage = pageController.page!;
      currentPageClamp = currentPage.clamp(0, 1);
    });
  }

  scrollControllerListener() {
    dy = initialDy - scrollController.offset;
    setState(() {});
  }

  getBackgroundCardInitialPosition() {
    RenderBox box = bankCardKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    dy = position.dy;
    initialDy = dy;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardsHeight = size.height * .65;

    // card list horizontal margin
    final horizontalMargin = (size.width * (1 - viewportFraction) / 2);

    // Background card positions
    final bgCardLeftPosition = horizontalMargin - 8;
    final bgCardRightPosition = horizontalMargin + 8;
    final bgCardBottomPosition =
        size.height - dy - cardsHeight + horizontalMargin;
    final bgCardTopPosition = (dy + horizontalMargin);

    // Background card border radius
    final borderRadius = currentPageClamp * 35;

    // Background card position x
    final backgroundCardPositionX = (currentPage > 1)
        ? ((1 - currentPage) * (size.width * viewportFraction))
        : 0.0;

    // Page view position
    final pageViewPositionX = (1 - currentPageClamp) * horizontalMargin;

    // card list physics
    final cardListPhysics = currentPageClamp < 1
        ? NeverScrollableScrollPhysics()
        : ClampingScrollPhysics();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background card
              _BackgroundCard(
                currentPageClamp: currentPageClamp,
                bgCardTopPosition: bgCardTopPosition,
                bgCardBottomPosition: bgCardBottomPosition,
                bgCardLeftPosition: bgCardLeftPosition,
                bgCardRightPosition: bgCardRightPosition,
                backgroundCardPositionX: backgroundCardPositionX,
                borderRadius: borderRadius,
              ),

              // Content
              ListView(
                physics: cardListPhysics,
                controller: scrollController,
                children: [
                  // User info
                  _UserInfo(currentPageClamp: currentPageClamp),
                  const SizedBox(height: 50),

                  // Stories list
                  _StoriesList(
                    bankCardKey: bankCardKey,
                    cardsHeight: cardsHeight,
                    pageViewPositionX: pageViewPositionX,
                    pageController: pageController,
                  ),
                  SizedBox(height: 50),
                ],
              ),

              // Expanded card
              _ExpandedCard(
                currentPageClamp: currentPageClamp,
                pageController: pageController,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackgroundCard extends StatelessWidget {
  const _BackgroundCard({
    Key? key,
    required this.currentPageClamp,
    required this.bgCardTopPosition,
    required this.bgCardBottomPosition,
    required this.bgCardLeftPosition,
    required this.bgCardRightPosition,
    required this.backgroundCardPositionX,
    required this.borderRadius,
  }) : super(key: key);

  final double currentPageClamp;
  final double bgCardTopPosition;
  final double bgCardBottomPosition;
  final double bgCardLeftPosition;
  final double bgCardRightPosition;
  final double backgroundCardPositionX;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: currentPageClamp * bgCardTopPosition,
      bottom: currentPageClamp * bgCardBottomPosition,
      left: currentPageClamp * bgCardLeftPosition,
      right: currentPageClamp * bgCardRightPosition,
      child: Transform.translate(
        offset: Offset(backgroundCardPositionX, 0),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    Key? key,
    required this.currentPageClamp,
  }) : super(key: key);

  final double currentPageClamp;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: currentPageClamp,
      child: Transform.translate(
        offset: Offset(0, -(1 - currentPageClamp) * 100),
        child: UserInfo(),
      ),
    );
  }
}

class _StoriesList extends StatelessWidget {
  const _StoriesList({
    Key? key,
    required this.bankCardKey,
    required this.cardsHeight,
    required this.pageViewPositionX,
    required this.pageController,
  }) : super(key: key);

  final GlobalKey<State<StatefulWidget>> bankCardKey;
  final double cardsHeight;
  final double pageViewPositionX;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bankCardKey,
      height: cardsHeight,
      child: Transform.translate(
        offset: Offset(pageViewPositionX, 0),
        child: PageView.builder(
          controller: pageController,
          itemCount: cards.length,
          itemBuilder: (context, i) {
            final card = cards[i];
            if (card == null) return Container();

            return StoryCard(
              storyCardModel: card,
            );
          },
        ),
      ),
    );
  }
}

class _ExpandedCard extends StatelessWidget {
  const _ExpandedCard({
    Key? key,
    required this.currentPageClamp,
    required this.pageController,
  }) : super(key: key);

  final double currentPageClamp;
  final PageController pageController;

  void onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 500) {
      pageController.animateToPage(1,
          duration: Duration(milliseconds: 450), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 150),
      child: currentPageClamp < .2
          ? GestureDetector(
              onHorizontalDragEnd: onHorizontalDragEnd,
              child: ExpandedCard(),
            )
          : const SizedBox.shrink(),
    );
  }
}
