import 'package:challenges/job_search_platform/data/job_cards_data.dart';
import 'package:challenges/job_search_platform/models/job_card_model.dart';
import 'package:challenges/job_search_platform/ui/job_detail/job_detail_view.dart';
import 'package:challenges/job_search_platform/ui/job_search/widgets/background.dart';
import 'package:challenges/job_search_platform/ui/job_search/widgets/job_name.dart';
import 'package:challenges/job_search_platform/ui/job_search/widgets/job_results.dart';
import 'package:challenges/job_search_platform/ui/widgets/job_card_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobSearchView extends StatelessWidget {
  const JobSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _BackButton(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Background(),
              const JobName(jobName: 'Product Designer Vacancies'),
              const JobResult(resultLength: 260, locationName: 'San Francisco'),
              const _JobCardList(),
            ],
          );
        },
      ),
    );
  }
}

class _JobCardList extends StatelessWidget {
  const _JobCardList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * .70;
        final cardHeight = 200;
        final maxVerticalScroll = 125.0;

        final listViewPaddingLeft = cardWidth * .4;
        final listViewPaddingTop = constraints.maxHeight - cardHeight - maxVerticalScroll;

        return Transform.translate(
          offset: Offset(0, maxVerticalScroll),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView.custom(
              padding: EdgeInsets.only(left: listViewPaddingLeft, top: listViewPaddingTop),
              scrollDirection: Axis.horizontal,
              childrenDelegate: SliverChildBuilderDelegate(
                (_, i) {
                  return _JobCard(
                    cardWidth: cardWidth,
                    jobCard: jobCardsData[i],
                    maxVerticalScroll: maxVerticalScroll,
                  );
                },
                childCount: jobCardsData.length,
              ),
            ),
          ),
        );
      },
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

  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    setState(() {
      dy = (initialPosition - details.globalPosition.dy).clamp(0, widget.maxVerticalScroll);
    });

    if (dy == widget.maxVerticalScroll) {
      cardState = CardState.expanding;
      await Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 950),
          reverseTransitionDuration: Duration(milliseconds: 950),
          pageBuilder: (context, animation, secondaryAnimation) {
            return JobDetailView(
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
  }

  void _onVerticalDragStart(details) {
    setState(() {
      initialPosition = details.globalPosition.dy;
      cardState = CardState.draging;
    });
  }

  void _onVerticalDragEnd(details) {
    setState(() {
      if (cardState != CardState.expanding) {
        dy = 0;
      }
    });
  }

  Widget _flightShuttleBuilder(
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
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Hero(
              tag: 'job-${widget.jobCard.id}',
              flightShuttleBuilder: _flightShuttleBuilder,
              child: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  color: Colors.black,
                ),
                child: JobCardContent(
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

enum CardState { initial, draging, expanding }

class _BackButton extends StatelessWidget {
  const _BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Color(0xffDCDEE9),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
