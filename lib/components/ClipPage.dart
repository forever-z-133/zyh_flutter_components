import 'package:flutter/material.dart';

class ClipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: ClipPath(
        clipper: _ClipPagePath(),
        child: Container(
          color: Colors.grey,
        ),
        // child: Align(
        //   alignment: Alignment.topLeft,
        //   child: Image.network(
        //     'https://picsum.photos/${width.round()}/${height.round()}'
        //   ),
        // )
      ),
    );
  }
}

class _ClipPagePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double radius = 100;
    return Path()
    ..moveTo(radius, 0)
    ..lineTo(width - radius, 0)
    ..quadraticBezierTo(width, 0, width, radius)
    ..lineTo(width, radius)
    ..lineTo(width, height - radius)
    ..quadraticBezierTo(width, height, width - radius, height)
    ..lineTo(width - radius, height)
    ..lineTo(radius, height)
    ..quadraticBezierTo(0, height, 0, height - radius)
    ..lineTo(0, height - radius)
    ..lineTo(0, radius)
    ..quadraticBezierTo(0, 0, radius, 0)
    ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
