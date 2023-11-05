import 'package:flutter/cupertino.dart';
import 'horiz_progress_painter.dart';


class HorizontProgressWidget extends StatefulWidget {
  const HorizontProgressWidget({
    required this.currentValue,
    required this.min,
    required this.max,
    Key? key
  }) : super(key: key);

  final double currentValue;
  final double min;
  final double max;

  @override
  State<HorizontProgressWidget> createState() => _HorizontProgressWidgetState();
}

class _HorizontProgressWidgetState extends State<HorizontProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFFCBE1EF),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        // border: Border.all(width: 2, color: Color(0xFF7F7F7F))
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomPaint(
            painter: HorizonDisplayPainter(
              min: widget.min,
              max: widget.max,
              value: widget.currentValue
            ),
          );
        },

      ),
    );
  }
}
