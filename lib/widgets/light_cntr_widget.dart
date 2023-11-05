import 'package:flutter/cupertino.dart';
import 'display_widget.dart';
import 'knob_widget.dart';


class LightControlWidget extends StatefulWidget {
  const LightControlWidget({
    Key? key
  }) : super(key: key);


  @override
  State<LightControlWidget> createState() => _LightControlWidgetState();
}

class _LightControlWidgetState extends State<LightControlWidget> {


  double currentValue = 80.0;
  double min = 40.0;
  double max = 100.0;
  String unit = "%";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const SizedBox(height: 40,),
          SizedBox(
            width: 320,
            height: 190,
            child: DisplayWidget(currentValue: currentValue, unit: unit,
              min: min, max: max),
          ),
          const SizedBox(height: 40,),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: KnobWidget(
                  value: currentValue,
                  min: min,
                  max: max,
                  step: 1.0,
                  unit: unit,
                  onChange: (double value) {
                    setState(() {
                      currentValue = value;
                    });
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}
