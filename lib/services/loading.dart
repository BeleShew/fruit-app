import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/keys.dart';

class ShowEasyLoading{
  static bool _isShowing = false;
  static OverlayEntry? _overlayEntry;
  static showCircleLoading({required context}) async {
    OverlayState? overlayState= Overlay.of(context);
    overlayState.insert(_overlayEntry!);
  }

  static showDotedProgress({required context}) async{
    // OverlayState overlayState = Overlay.of(context);
    // OverlayEntry overlayEntry = OverlayEntry(
    //     builder: (context) {
    //       return SafeArea(
    //         child: Stack(
    //           children: [
    //             Opacity(
    //               opacity: 0.7,
    //               child: Container(
    //                 color: Keys.backGroundColor,
    //               ),
    //             ),
    //             Center(
    //                 child: Container(
    //                   height: 100,
    //                   width: 100,
    //                   decoration: BoxDecoration(
    //                     color: Keys.primaryButtonColor,
    //                     borderRadius:const BorderRadius.all(
    //                         Radius.circular(10)
    //                     ),
    //                   ),
    //                   child:Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       DottedCircularProgressIndicator(
    //                         colors: [Colors.green.shade900,Colors.yellow.shade900,Colors.red.shade900],
    //                         dotSize: 5,
    //                         dotCount: 15,
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //             ),
    //           ],
    //         ),
    //       );
    //     });
    // overlayState.insert(overlayEntry);
    if (_isShowing) return;
    _isShowing = true;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return buildOverlayContent();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry!);
    });
  }
  static dismisLoading() async{
    try{
      if (_isShowing) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _isShowing = false; // Reset the flag after dismissing
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
  static Widget buildOverlayContent() {
    return SafeArea(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Keys.primaryButtonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DottedCircularProgressIndicator(
                    colors: [
                      Colors.green.shade900,
                      Colors.yellow.shade900,
                      Colors.red.shade900,
                    ],
                    dotSize: 5,
                    dotCount: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedCircularProgressIndicator extends StatefulWidget {
  final double radius;
  final List<Color> colors;
  final double dotSize;
  final int dotCount;
  final double animationDuration;

  const DottedCircularProgressIndicator({
    Key? key,
    this.radius = 30.0,
    this.colors = const [Colors.blue],
    this.dotSize = 6.0,
    this.dotCount = 10,
    this.animationDuration = 1000,
  }) : super(key: key);

  @override
  DottedCircularProgressIndicatorState createState() =>
      DottedCircularProgressIndicatorState();
}

class DottedCircularProgressIndicatorState extends State<DottedCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration.toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = _animationController.value;
        return CustomPaint(
          painter: _DottedCirclePainter(
            radius: widget.radius,
            colors: widget.colors,
            dotSize: widget.dotSize,
            dotCount: widget.dotCount,
            animationValue: animationValue,
          ),
          child: Container(
            width: widget.radius * 2,
            height: widget.radius * 2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              // color: widget.colors[0], // Use the first color from the list
            ),
          ),
        );
      },
    );
  }
}
class _DottedCirclePainter extends CustomPainter {
  final double radius;
  final List<Color> colors;
  final double dotSize;
  final int dotCount;
  final double animationValue;

  _DottedCirclePainter({
    required this.radius,
    required this.colors,
    required this.dotSize,
    required this.dotCount,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double angle = 2 * 3.1415926535897932 / dotCount;

    for (int i = 0; i < dotCount; i++) {
      final double x = centerX + (radius * cos(i * angle));
      final double y = centerY + (radius * sin(i * angle));

      final int colorIndex = i % colors.length;
      final Color dotColor = colors[colorIndex];

      final double animatedValue = (animationValue - (i / dotCount)) % 1;

      if (animatedValue > 0 && animatedValue < 0.5) {
        final paint = Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}