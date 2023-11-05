import 'package:flutter/cupertino.dart';
import 'horiz_progress_widget.dart';


class DisplayWidget extends StatefulWidget {
  const DisplayWidget({
    required this.currentValue,
    required this.unit,
    required this.min,
    required this.max,
    Key? key
  }) : super(key: key);

  final double currentValue;
  final double min;
  final double max;
  final String unit;

  @override
  State<DisplayWidget> createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {

  String getStringValue() {
    return "${((100.0 / 60.0 * (widget.currentValue - widget.min))).round()}%";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 170,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 10, color: Color(0xFF2A2A2A)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: const Color(0xFFCBE1EF)
      ),
      child: Center(
        child: Column(
          children: [
            Text(getStringValue(),
              style: const TextStyle(fontSize: 60, color: Color(0xFF000000)),
            ),
            const SizedBox(height: 10,),
            HorizontProgressWidget(currentValue: widget.currentValue, min: widget.min,
              max: widget.max,)
          ],
        ),
      ),
    );
  }
}
