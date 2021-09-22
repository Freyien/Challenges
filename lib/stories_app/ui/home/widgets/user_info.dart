import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          'lib/stories_app/assets/4.png',
          width: double.infinity,
          height: size.height * .25,
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: size.height * .1,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    child: Image.asset(
                  'lib/stories_app/assets/user1.jpg',
                  height: size.height * .2,
                  width: size.height * .2,
                  fit: BoxFit.cover,
                )),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Asuka Langley',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.lightBlue,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Various version have evolved',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: Colors.grey),
            )
          ],
        )
      ],
    );
  }
}
