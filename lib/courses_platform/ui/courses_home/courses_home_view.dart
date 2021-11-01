import 'package:challenges/courses_platform/ui/recomended_detail/recomended_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CoursesHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Color(0xffCACFE2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            hoverColor: Colors.red,
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'lib/courses_platform/assets/user1.jpg',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final cardHeight = constraints.maxHeight * .23;
        final cardWidth = constraints.maxWidth * .45;

        return Stack(
          children: [
            Positioned(
              top: 35,
              left: 8,
              child: ClipOval(
                child: Container(
                  height: 170,
                  width: 170,
                  color: Color(0xffB8B8D3).withOpacity(.5),
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 120,
              child: ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Color(0xffB8B8D3).withOpacity(.5),
                ),
              ),
            ),
            Positioned(
              right: 60,
              top: 170,
              child: ClipOval(
                child: Container(
                  height: 70,
                  width: 70,
                  color: Color(0xffB8B8D3).withOpacity(.5),
                ),
              ),
            ),
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      const Text(
                        'John',
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.grey[200]!,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Search courses',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        height: 50,
                        width: 50,
                        child: Material(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {},
                            child: const Icon(
                              Icons.sort,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.black54,
                        ),
                        child: const Text('View All'),
                      )
                    ],
                  ),
                ),
                Container(
                  height: cardHeight,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 8, right: 24),
                    itemBuilder: (context, i) {
                      return Container(
                        width: cardWidth,
                        padding: const EdgeInsets.only(left: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'lib/courses_platform/assets/4.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.white,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Design',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      '165 courses',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Recomended',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.black54,
                        ),
                        child: const Text('View All'),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 130,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 8, right: 24),
                    itemBuilder: (context, i) {
                      final tag = 'course-recomended-$i';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 900),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return RecomendedDetailView(
                                  tag: tag,
                                );
                              },
                              transitionsBuilder: (context, animation, _, child) {
                                if (animation.status == AnimationStatus.reverse) {
                                  return SlideTransition(
                                    position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                                        .animate(animation),
                                    child: child,
                                  );
                                }

                                return child;
                              },
                            ),
                          );
                        },
                        child: Hero(
                          tag: tag,
                          flightShuttleBuilder: _flightShuttleBuilder,
                          child: Container(
                            width: constraints.maxWidth - 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                            margin: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Angular - The Complete Guide',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Teaching & Academics',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        color: Colors.deepOrangeAccent.withOpacity(.9),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '4.9',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      '56 hours',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
