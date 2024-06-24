import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:sensors/sensors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GasContainerRippler(
            containerBorder: Colors.blue,
            gasColor: Colors.blue.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class GasContainerRippler extends StatefulWidget {
  final Color gasColor, containerBorder;

  const GasContainerRippler({
    super.key,
    required this.gasColor,
    required this.containerBorder,
  });

  @override
  State<GasContainerRippler> createState() => _GasContainerRipplerState();
}

class _GasContainerRipplerState extends State<GasContainerRippler>
    with TickerProviderStateMixin {
  late AnimationController waveController;

  double rotationAngle = 0.0;

  @override
  void initState() {
    super.initState();
    waveController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() => waveController.value = 0.0);
        }
      })
      ..repeat(reverse: true);

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() => rotationAngle = (event.x / 10) * math.pi / 4);
    });
  }

  @override
  void dispose() {
    waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, child) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.containerBorder,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: SizedBox(
            width: 150.r,
            height: 200.r,
            child: CustomPaint(
              painter: SineWavePainter(
                color: widget.gasColor,
                animationValue: waveController.value,
                value: 200.r * 0.5,
                // TODO: Change this to reflect the value of the gas left in the container
                rotationAngle: rotationAngle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SineWavePainter extends CustomPainter {
  final double value;
  final double animationValue;
  final double rotationAngle;
  final Color color;

  SineWavePainter({
    required this.color,
    required this.rotationAngle,
    required this.animationValue,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    double centerY = value;

    path.moveTo(0, centerY);

    double amplitude = 2.5 * (1 + math.sin(animationValue * math.pi)) / 2;
    double frequency = 0.1 + animationValue * 0.05;
    double phase = animationValue * 2 * math.pi;

    for (int i = 0; i < size.width.toInt(); i++) {
      final x = i.toDouble();
      final y = amplitude * math.sin(frequency * x + phase);
      path.lineTo(x, y + centerY);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
