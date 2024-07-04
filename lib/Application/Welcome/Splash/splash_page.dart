import 'package:flutter/material.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(500, 500),
              painter: CurvedLinePainter([AppColors.pink, AppColors.transparentBlack]),
            ),
          ),

          Center(
            child: Text(
              "Test App",
              style: AppTextStyles.style0
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: CurvedLinePainter([AppColors.pink, AppColors.transparentBlack], isBottom: true),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedLinePainter extends CustomPainter {final List<Color> colors; // Gradient ranglari
final bool isBottom;

CurvedLinePainter(this.colors, {this.isBottom = false});

@override
void paint(Canvas canvas, Size size) {
  final rect = Offset.zero & size;
  final gradient = LinearGradient(
    begin: isBottom ? const Alignment(0, .1) : const Alignment(0, .4),
    end: isBottom ? Alignment.bottomCenter : Alignment.topCenter,
    colors: colors,
  );

  final paint = Paint()
    ..shader = gradient.createShader(rect)
    ..style = PaintingStyle.fill;

  final path = Path();
  if (isBottom) {
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 10, size.height / 5, size.width * 3.3, size.height * 1.1);
  } else {
    path.moveTo(-size.width, 0);
    path.quadraticBezierTo(size.width * .8, size.height * 1.3, size.width, 0);
  }
  canvas.drawPath(path, paint);
}

@override
bool shouldRepaint(CustomPainter oldDelegate) => false;
}
