import 'package:flutter/cupertino.dart';


class HorizonDisplayPainter extends CustomPainter {

  HorizonDisplayPainter({
    required this.min, required this.max, required this.value
  });

  final double min;
  final double max;
  final double value;

  final double dashWidth = 6.0;
  final double spaceBtwDashes = 3.0;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20.0
        ..color = Color(0xFF4B4B4B);
    var start = Offset(0 + 5, size.height / 2.0);
    final currentValueInPercent = (100.0 / (max - min) * (value - min));
    final partsCount = (size.width - 10) * currentValueInPercent / 100.0 / (dashWidth + spaceBtwDashes) ~/ 1;

    for(var i=0; i <= partsCount; ++i) {
      final end = Offset(start.dx + dashWidth, start.dy);
      canvas.drawLine(start, end, painter);
      start = Offset(start.dx + dashWidth + spaceBtwDashes, start.dy);

    }
    // canvas.drawLine(start, finish, painter);
  }



}