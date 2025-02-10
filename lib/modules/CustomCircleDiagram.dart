import 'package:flutter/material.dart';

class CustomCircleDiagram extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color strokeColor;
  final double max;
  final double value;

  const CustomCircleDiagram({super.key, required this.max, required this.value, required this.size, required this.strokeColor, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        Center(
          child: Padding(padding: EdgeInsets.all((size / 2) * 0.3), child: CustomPaint(
            size: Size(size, size),
            painter: _CirclePainter(percentage: value / max, color: strokeColor, backgroundColor: backgroundColor),
          ),),
        ),
        Column(
          children: [
            SizedBox(height: size/2,),
            Center(
              child: Text("${value.toInt()}", style: TextStyle(fontSize: size / 5, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  _CirclePainter({required this.percentage, required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.4;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = radius * 0.4;

    canvas.drawCircle(center, radius, backgroundPaint);

    final arcAngle = 2 * 3.14159265359 * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265359 / 2,
      arcAngle,
      false,
      arcPaint
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color || oldDelegate.backgroundColor != backgroundColor;
  }

}