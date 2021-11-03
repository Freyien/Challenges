import 'package:challenges/courses_platform/data/courses_categories_data.dart';
import 'package:challenges/courses_platform/ui/widgets/fade_slide_transition.dart';
import 'package:flutter/material.dart';

class CategoriesDetailView extends StatelessWidget {
  const CategoriesDetailView({Key? key, required this.tag}) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffCACFE2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                collapsedHeight: 65,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                leading: const SizedBox.shrink(),
                flexibleSpace: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        'Development',
                        style: TextStyle(
                          letterSpacing: .7,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    background: Image.asset(
                      'lib/courses_platform/assets/4.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24, bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(13),
                            color: Colors.black,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(13),
                              onTap: () {},
                              child: const Icon(
                                Icons.sort,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(left: 15),
                              scrollDirection: Axis.horizontal,
                              itemCount: coursesCategoriesData.length,
                              itemBuilder: (context, i) {
                                return _CategoryButton();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: 20,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Angular - The Complete Guide',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '42 lectures',
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_filled_sharp,
                                        size: 18,
                                        color: Color(0xff8D89B4),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '86 hrs',
                                        style: TextStyle(color: Color(0xff8D89B4)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Color(0xff8D89B4),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '4.9',
                                        style: TextStyle(color: Color(0xff8D89B4)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people_alt,
                                        size: 18,
                                        color: Color(0xff8D89B4),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '30 245',
                                        style: TextStyle(color: Color(0xff8D89B4)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // SliverPadding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   sliver: SliverList(
            //     delegate: SliverChildBuilderDelegate(
            //       (BuildContext context, int index) {

            //       },
            //       childCount: 20,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatefulWidget {
  const _CategoryButton({
    Key? key,
  }) : super(key: key);

  @override
  State<_CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<_CategoryButton> with TickerProviderStateMixin {
  late AnimationController fadeSlideController;
  late AnimationController sizeController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();

    fadeSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    sizeAnimation = Tween<double>(begin: 1, end: 0).animate(sizeController);

    fadeSlideController.addListener(fadeSlideListener);
  }

  void fadeSlideListener() {
    if (fadeSlideController.status != AnimationStatus.completed) return;

    sizeController.forward();
  }

  @override
  void dispose() {
    fadeSlideController.removeListener(fadeSlideListener);
    fadeSlideController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      animation: fadeSlideController,
      beginOpacity: 1,
      endOpacity: 0,
      interval: Interval(0, 1),
      beginOffset: Offset(0, 0),
      endOffset: Offset(0, -.3),
      child: SizeTransition(
        axis: Axis.horizontal,
        axisAlignment: -1,
        sizeFactor: sizeAnimation,
        child: Container(
          margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              textStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              fadeSlideController.forward();
            },
            child: Row(
              children: [
                Icon(Icons.close, size: 12),
                const SizedBox(width: 3),
                Text('coursesCategoriesData[i]'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
