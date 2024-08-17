import 'dart:math';

import 'package:flutter/material.dart';

class InjectorCard extends StatefulWidget {
  final int injectorNumber;
  final String tank;
  final String volume;
  final int preMix;
  final int fertigation;
  final int postMix;
  final bool isSimultaneousMode;
  final String mode; // Add this line

  const InjectorCard({
    required this.injectorNumber,
    required this.tank,
    required this.volume,
    required this.preMix,
    required this.fertigation,
    required this.postMix,
    required this.isSimultaneousMode,
    required this.mode, // Add this line
  });

  @override
  _InjectorCardState createState() => _InjectorCardState();
}

class _InjectorCardState extends State<InjectorCard> {
  late double _currentFertigation;

  @override
  void initState() {
    super.initState();
    _currentFertigation = widget.fertigation.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Injector ', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 23), ),// Make "Injector" bold
                Text('${widget.injectorNumber}', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text('Tank ', style: const TextStyle(fontWeight: FontWeight.bold)), // Make "Tank" bold
                Text(widget.tank),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text('Volume ', style: const TextStyle(fontWeight: FontWeight.bold)), // Make "Volume" bold
                Text('${widget.volume} liters'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text('Mode ', style: const TextStyle(fontWeight: FontWeight.bold)), // Make "Mode" bold
                Text('${widget.mode}'), // Add this line
              ],
            ),
            const SizedBox(height: 8.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Added padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Pre Mix:'),
                            Text('${widget.preMix} mins', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Fertigation:'),
                            Text('${_currentFertigation.round()} mins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Post Mix:'),
                            Text('${widget.postMix} mins', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: CustomSlider(
                            value: _currentFertigation, // Ensure the slider starts from the fertigation value
                            min: 0,
                            max: 60.0, // Updated max value to 60 minutes
                            preMix: widget.preMix.toDouble(),
                            postMix: widget.postMix.toDouble(),
                            onChanged: widget.isSimultaneousMode ? null : (value) {
                              setState(() {
                                _currentFertigation = value;
                              });
                            },
                            isSimultaneousMode: widget.isSimultaneousMode, // Pass the mode
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double preMix;
  final double postMix;
  final ValueChanged<double>? onChanged;
  final bool isSimultaneousMode; // Add this line

  const CustomSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.preMix,
    required this.postMix,
    this.onChanged,
    required this.isSimultaneousMode, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 13.0,
        thumbShape: CustomSliderThumbShape(
          preMix: preMix,
          postMix: postMix,
          min: min,
          max: max,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        thumbColor: const Color.fromARGB(255, 148, 220, 151),
        activeTrackColor: Colors.grey.shade300,
        inactiveTrackColor: Colors.grey.shade300,
        trackShape: RectangularSliderTrackShape(
          preMix: preMix,
          postMix: postMix,
          min: min,
          max: max,
          isSimultaneousMode: isSimultaneousMode, // Pass the mode
        ),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

class RectangularSliderTrackShape extends SliderTrackShape {
  final double preMix;
  final double postMix;
  final double min;
  final double max;
  final bool isSimultaneousMode; // Add this line

  const RectangularSliderTrackShape({
    required this.preMix,
    required this.postMix,
    required this.min,
    required this.max,
    required this.isSimultaneousMode, // Add this line
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;

    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset? secondaryOffset,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    context.canvas.drawRect(trackRect, inactivePaint);

    context.canvas.drawRect(
      Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx,
        trackRect.bottom,
      ),
      activePaint,
    );

    // Draw vertical dashes for preMix and postMix
    final double preMixPosition = offset.dx + (sliderTheme.trackHeight ?? 2.0) + (parentBox.size.width * (preMix - this.min) / (this.max - this.min));
    final double postMixPosition = offset.dx + (sliderTheme.trackHeight ?? 2.0) + (parentBox.size.width * (this.max - postMix) / (this.max - this.min)); // Adjusted postMix position

    final Paint dashPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..strokeWidth = 2.0;

    // Draw vertical dashes for preMix and postMix in both simultaneous and sequential modes
    context.canvas.drawLine(
      Offset(preMixPosition, trackRect.top),
      Offset(preMixPosition, trackRect.bottom),
      dashPaint,
    );

    context.canvas.drawLine(
      Offset(postMixPosition, trackRect.top),
      Offset(postMixPosition, trackRect.bottom),
      dashPaint,
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double preMix;
  final double postMix;
  final double min;
  final double max;

  const CustomSliderThumbShape({
    required this.preMix,
    required this.postMix,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(120.0, 25.0); // Adjust the size as needed
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    // Adjust the thumb position to start from the fertigation value
    final double thumbWidth = getPreferredSize(true, false).width;
    final Rect thumbRect = Rect.fromCenter(
      center: Offset(center.dx + thumbWidth / 2, center.dy),
      width: thumbWidth,
      height: getPreferredSize(true, false).height,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(thumbRect, Radius.circular(10.0)),
      paint,
    );
  }
}