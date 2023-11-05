import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'knob_painter.dart';


class KnobWidget extends StatefulWidget {
  const KnobWidget({
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
    required this.onChange,
    Key? key
  }) : super(key: key);

  final double value;
  final double min;
  final double max;
  final double step;
  final String unit;
  final ValueChanged<double> onChange;

  @override
  State<KnobWidget> createState() => _KnobWidgetState();
}

class _KnobWidgetState extends State<KnobWidget> {

  double value = 0.0;

  double computeValueFromThumb(Offset thumb, Size size,
      double minAngle, double maxAngle) {
    final polar = cartesianToPolar(thumb, size);
    var thetaR = polar.dy;

    if (thetaR > 0 && thetaR < pi / 2.0) {
      thetaR += 2 * pi;
    }
    final minAngleR = minAngle * pi / 180;
    final maxAngleR = maxAngle * pi / 180 + 2 * pi;

    if (thetaR > maxAngleR) {
      thetaR = maxAngleR;
    }
    if (thetaR < minAngleR) {
      thetaR = minAngleR;
    }

    final angleRangeR = maxAngleR - minAngleR;
    final unitPerAngle = (widget.max - widget.min) / angleRangeR;

    return widget.min + unitPerAngle * (thetaR - minAngleR);
  }

  Offset cartesianToPolar(Offset position, Size size) {
    double x = position.dx;
    double y = position.dy;

    x -= size.width / 2.0;
    y -= size.height / 2.0;

    final double radius = sqrt(x * x + y * y);
    final double theta = (atan2(x, -y) - pi / 2.0) % (2 * pi);
    return Offset(radius, theta);
  }

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        double maxAngle = 45;
        double minAngle = 135;
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              value = computeValueFromThumb(
                details.localPosition, Size(width, height), minAngle, maxAngle
              );

              if (value < widget.min) {
                value = widget.min;
              }
              if (value > widget.max) {
                value = widget.max;
              }
              widget.onChange(value);
            });
          },
          child: CustomPaint(
            painter: KnobPainter(
              value: value,
              min: widget.min,
              max: widget.max,
              step: widget.step,
              unit: widget.unit,
              minAngle: minAngle,
              maxAngle: maxAngle
            ),
            child: Container(),
          ),
        );
      }
    );
  }
}
