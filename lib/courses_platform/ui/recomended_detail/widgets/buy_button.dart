import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  const BuyButton({
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
