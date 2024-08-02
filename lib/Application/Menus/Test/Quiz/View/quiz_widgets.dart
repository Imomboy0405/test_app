import 'package:flutter/material.dart' hide ThemeMode;
import 'dart:math' as math;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';

class MyQuizButton extends StatelessWidget {
  final String text;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;
  final String? ball;
  final bool selected;
  final bool animeRight;

  const MyQuizButton({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.ball,
    required this.selected,
    required this.animeRight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      delay: const Duration(milliseconds: 50),
      position: value,
      child: SlideAnimation(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        horizontalOffset: MediaQuery.of(context).size.width / (animeRight ? 2 : -2),
        verticalOffset: 0.0,
        child: FlipAnimation(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          flipAxis: FlipAxis.y,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * .02),
            child: Container(
              decoration: BoxDecoration(
                color: groupValue == value ? AppColors.pink : AppColors.transparentBlack,
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .04),
                border: Border.all(color: groupValue == value ? AppColors.pink : AppColors.black),
                boxShadow: [
                  BoxShadow(color: AppColors.pink.withOpacity(0.3), blurRadius: 5, spreadRadius: 2, offset: const Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .04),
                child: MaterialButton(
                  splashColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.pink,
                  highlightColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.pink,
                  onPressed: () => ball != null ? null : onChanged(value),
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .03, vertical: MediaQuery.of(context).size.width * .01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${ball != null ? "$ball ${'ball'.tr()}. " : ''}$text',
                          style: groupValue == value ? AppTextStyles.style18(context) : AppTextStyles.style18_0(context),
                        ),
                      ),
                      Transform.scale(
                        scale: MediaQuery.of(context).size.width / 500,
                        child: Radio<int>(
                          value: value,
                          groupValue: groupValue,
                          onChanged: (v) => ball != null ? null : onChanged(v),
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            if (selected) {
                              return AppColors.transparent;
                            } else if (states.contains(WidgetState.selected)) {
                              return AppColors.black;
                            } else {
                              return AppColors.purple;
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HudProgressIndicator extends StatefulWidget {
  const HudProgressIndicator({super.key, required this.progress});

  final double progress;

  @override
  State<HudProgressIndicator> createState() => _HudProgressIndicatorState();
}

class _HudProgressIndicatorState extends State<HudProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .8,
      height: MediaQuery.sizeOf(context).width * .4,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _HudProgressPainter(_animation.value, context),
          );
        },
      ),
    );
  }
}

class _HudProgressPainter extends CustomPainter {
  _HudProgressPainter(this.progress, this.context);

  final double progress;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final arcAngle = 4.74159265359 * progress;

    // #background_progress
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .07;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.33159265359,
      4.76159265359,
      false,
      backgroundPaint,
    );

    // #progress
    final progressPaint = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .06;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.34159265359,
      arcAngle,
      false,
      progressPaint,
    );

    final borderPaint = Paint()
    // #draw_circle
      ..color = Colors.white.withOpacity(.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .005;
    canvas.drawCircle(center, size.width * .17, borderPaint);

    final circlePaint = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * .166, circlePaint);

    // $draw_texts
    _drawText(canvas, center, radius, '0', 2.24159265359, -size.width * .1, -size.width * .01);
    _drawText(canvas, center, radius, '20', 2.24159265359 + 4.74159265359 / 5,  size.width * .8, -size.width * .09);
    _drawText(canvas, center, radius, '40', 2.24159265359 + 4.74159265359 * 2 / 5, -size.width * .07, -size.width * .09);
    _drawText(canvas, center, radius, '60', 2.24159265359 + 4.74159265359 * 3 / 5, -size.width * .1, size.width * .05);
    _drawText(canvas, center, radius, '80', 2.24159265359 + 4.74159265359 * 4 / 5, -size.width * .25, -size.width * .08);
    _drawText(canvas, center, radius, '100', 2.24159265359 + 4.74159265359, -size.width * .05, -size.width * .12);
    _drawText(canvas, center, 0, '${(progress * 100).toInt()} %', 2.24159265359 + 4.74159265359, 0, 0, result: true);

    // #stick
    final pointerAngle = 2.34159265359 + arcAngle;
    final pointerLength = radius * 0.8;
    const pointerStartOffset = 0.344;
    final pointerStart = Offset(
      center.dx + (radius * pointerStartOffset) * math.cos(pointerAngle),
      center.dy + (radius * pointerStartOffset) * math.sin(pointerAngle),
    );
    final pointerEnd = Offset(
      center.dx + pointerLength * math.cos(pointerAngle),
      center.dy + pointerLength * math.sin(pointerAngle),
    );

    final Alignment begin, end;
    if (progress < 0.5) {
      begin = Alignment.centerRight;
      end = Alignment.centerLeft;
    } else {
      begin = Alignment.centerLeft;
      end = Alignment.centerRight;
    }
    final gradient = LinearGradient(
      colors: [AppColors.purpleAccent, AppColors.pink],
      begin: begin,
      end: end,
    );

    final thickPaint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(pointerStart, pointerEnd))
      ..strokeWidth = size.width * .045
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        pointerStart,
        Offset(
          center.dx + (pointerLength - size.width * .036) * math.cos(pointerAngle),
          center.dy + (pointerLength - size.width * .036) * math.sin(pointerAngle),
        ),
        Paint()..color = AppColors.whiteConst..strokeWidth = size.width * .051);

    canvas.drawLine(
        pointerStart,
        Offset(
          center.dx + (pointerLength - size.width * .04) * math.cos(pointerAngle),
          center.dy + (pointerLength - size.width * .04) * math.sin(pointerAngle),
        ),
        thickPaint);

    final thinPaint = Paint()
      ..color = AppColors.pink
      ..strokeWidth = size.width * .022
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
        Offset(
          center.dx + (pointerLength - size.width * .04) * math.cos(pointerAngle),
          center.dy + (pointerLength - size.width * .04) * math.sin(pointerAngle),
        ),
        pointerEnd,
        Paint()
          ..color = AppColors.whiteConst
          ..strokeWidth = size.width * .028
          ..style = PaintingStyle.stroke);
    canvas.drawLine(
        Offset(
          center.dx + (pointerLength - size.width * .04) * math.cos(pointerAngle),
          center.dy + (pointerLength - size.width * .04) * math.sin(pointerAngle),
        ),
        pointerEnd,
        thinPaint);

    canvas.drawCircle(pointerEnd, size.width * .021, Paint()..style = PaintingStyle.fill..color = AppColors.whiteConst);
    canvas.drawCircle(pointerEnd, size.width * .018, thinPaint..style = PaintingStyle.fill);
  }

  void _drawText(Canvas canvas, Offset center, double radius, String text, double angle, double verticalOffset, double horizontalOffset,
      {bool result = false}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: result
            ? AppTextStyles.style12(context).copyWith(color: Colors.white)
            : AppTextStyles.style18(context).copyWith(color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      center.dx + (radius + horizontalOffset) * math.cos(angle) - textPainter.width / 2,
      center.dy + (radius + verticalOffset) * math.sin(angle) - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}