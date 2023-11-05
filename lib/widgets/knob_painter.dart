import 'dart:math';

import 'package:flutter/cupertino.dart';


class KnobPainter extends CustomPainter {
  KnobPainter({ required this.value, required this.min, required this.max,
    required this.step, required this.unit, required this.maxAngle, required this.minAngle});

  double value;
  double min;
  double max;
  double step;
  String unit;
  double minAngle;
  double maxAngle;

  final Color dialColorLight = const Color(0xFF212121);
  final Color dialColorDark = const Color(0xFF1A1A1A);
  final double thickness = 20.0;
  final Paint markerPaintStroke = Paint()
    ..strokeWidth = 1.0
    ..color = Color(0xFFFFFFFF);
  final labelTS = const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF));
  final Paint indicatorDotPaint = Paint()
    ..color = Color(0xFF16E755)
    ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5);
  final Paint indicatorPainBlur = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..color = Color(0xFF16E755)
    ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2.0, size.height / 2.0);
    final rect = Rect.fromCenter(center: c, width: size.width, height: size.height);
    final r = size.width / 2.0;

    drawDial(canvas, rect, r);
    drawMinMaxGuides(canvas, c, r);
    drawScale(canvas, c, r);

    final r1 = r - thickness / 2.0;
    drawKnob(canvas, rect, r1);
    final rect1 = rect.deflate(thickness * 0.75);
    drawKnobEffects(canvas, rect1);
    drawIndicators(canvas, rect1, r);
  }

  drawDial(Canvas canvas, Rect rect, double radius) {
    final dialPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          dialColorLight,
          dialColorDark
        ]
      ).createShader(rect);
    canvas.drawCircle(rect.center, radius, dialPaint);

    dialPaint.strokeWidth = 1.0;
    canvas.drawCircle(rect.center, radius + thickness /2.0 + 2, dialPaint);
  }

  TextPainter measureText(String text, TextStyle style,
      double maxWidth, TextAlign textAlign) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span, textAlign: textAlign, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset c, String text,
      TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final offset = c + Offset(-tp.width / 2.0, -tp.height / 2.0);
    tp.paint(canvas, offset);
    return tp.size;
  }

  drawMinMaxGuides(Canvas canvas, Offset c, double r) {
    final minAngleR = minAngle * pi / 180.0;
    final maxAngleR = maxAngle * pi / 180.0;
    final minOffset = Offset(r * cos(minAngleR), r * sin(minAngleR));
    final maxOffset = Offset(r * cos(maxAngleR), r * sin(maxAngleR));

    canvas.drawLine(c, c + minOffset, markerPaintStroke);
    canvas.drawLine(c, c + maxOffset, markerPaintStroke);

    final d1 = r + 30.0;
    final minLabelOffset = Offset(d1 * cos(minAngleR), d1 * sin(minAngleR));
    final maxLabelOffset = Offset(d1 * cos(maxAngleR), d1 * sin(maxAngleR));

    drawTextCentered(
      canvas, c + minLabelOffset, min.toInt().toString(), labelTS, 50.0
    );
    drawTextCentered(
        canvas, c + maxLabelOffset, max.toInt().toString(), labelTS, 50.0
    );
  }
  void drawScale(Canvas canvas, Offset c, double r) {
    final minAngleR = minAngle * pi / 180;
    final maxAngleR = maxAngle * pi / 180 + 2 * pi;
    final angleRangeR = maxAngleR - minAngleR;
    final stepCount = (max - min) / step;
    final stepAngleR = angleRangeR / stepCount;
    int i =0;
    for (var a = minAngleR; a <= maxAngleR; a += stepAngleR) {
      if (i % 10 == 0) {
        final d1 = r -1.0;
        final offset = Offset(d1 * cos(a), d1 * sin(a));
        canvas.drawLine(c, c + offset, markerPaintStroke);
      } else if (i % 5 == 0) {
        final d2 = r -2.0;
        final offset = Offset(d2 * cos(a), d2 * sin(a));
        canvas.drawLine(c, c + offset, markerPaintStroke);
      } else {
        final d3 = r -4.0;
        final offset = Offset(d3 * cos(a), d3 * sin(a));
        canvas.drawLine(c, c + offset, markerPaintStroke);
      }
      i++;
    }
  }

  void drawKnob(Canvas canvas, Rect rect, double r) {
    final knobPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          dialColorLight,
          dialColorDark
        ]
      ).createShader(rect);
    canvas.drawCircle(rect.center, r, knobPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = dialColorDark
      ..strokeWidth = 3.0;
    canvas.drawCircle(rect.center, r + 1.0, borderPaint);
  }

  void drawKnobEffects(Canvas canvas, Rect rect) {
    final fg2Paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          dialColorDark,
          dialColorLight
        ]
      ).createShader(rect);
    canvas.drawCircle(rect.center, rect.width / 2.0, fg2Paint);
  }

  void drawIndicators(Canvas canvas, Rect rect, double r) {
    final minAngleR = minAngle * pi / 180;
    final maxAngleR = maxAngle * pi / 180 + 2 * pi;
    final angleRangeR = maxAngleR - minAngleR;
    final anglesPerUnit = angleRangeR / (max - min);
    final angleR = minAngleR + anglesPerUnit * (value - min);

    final r1 = r - 25.0;
    final d = Offset(r1 * cos(angleR), r1 * sin(angleR));
    canvas.drawCircle(rect.center + d, 3.5, indicatorDotPaint);
    
    canvas.drawArc(rect, minAngleR, angleR - minAngleR, false, indicatorPainBlur);
  }

}