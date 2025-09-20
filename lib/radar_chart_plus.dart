library;
import 'dart:math';
import 'package:flutter/material.dart';

class RadarChartCustomPaint extends StatelessWidget {
  final List<int> ticks;
  final List<String> features;
  final List<double> data;
  final Color chartBorderColor;
  final Color chartFillColor;
  final Color? dotColor;

  const RadarChartCustomPaint({
    super.key,
    required this.ticks,
    required this.features,
    required this.data,
    required this.chartBorderColor,
    required this.chartFillColor,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: RadarChartPainter(
        borderColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.5),
        labelColor: Theme.of(context).colorScheme.onSurface,
        ticks: ticks,
        features: features,
        data: data,
        chartBorderColor: chartBorderColor,
        chartFillColor: chartFillColor,
      ),
    );
  }
}

/// The custom painter that draws the radar chart.
class RadarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<double> data;

  RadarChartPainter({
    required this.labelColor,
    required this.borderColor,
    required this.ticks,
    required this.features,
    required this.data,
    required this.chartBorderColor,
    required this.chartFillColor,
    this.dotColor,
  });

  final Color chartBorderColor;
  final Color chartFillColor;
  final Color? dotColor;
  final Color labelColor;
  final Color borderColor;

  final List<double> labelAngle = const [
    0.0,
    pi / 3,
    300 * pi / 180,
    0,
    pi / 3,
    300 * pi / 180,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = min(centerX, centerY) * 0.8;
    final angleStep = (2 * pi) / features.length;

    // 1. Draw the grey concentric circles (ticks)
    final tickPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var tick in ticks) {
      final tickRadius = radius * tick / ticks.last;
      canvas.drawCircle(centerOffset, tickRadius, tickPaint);
    }

    // 2. Draw the tick labels (e.g., 5, 10, 15, 20)
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (var tick in ticks) {
      final tickRadius = radius * tick / ticks.last;
      textPainter.text = TextSpan(
        text: tick.toString(),
        style: TextStyle(color: labelColor, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - (textPainter.width / 2) + 5,
          centerY - (tickRadius - textPainter.height / 2) - 2,
        ),
      );
    }

    // 3. Draw the spokes and feature labels
    final featureLinePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    features.asMap().forEach((index, feature) {
      final currentAngle = angleStep * index - pi / 2;
      final x = centerX + radius * cos(currentAngle);
      final y = centerY + radius * sin(currentAngle);
      final featureOffset = Offset(x, y);
      canvas.drawLine(centerOffset, featureOffset, featureLinePaint);

      // Draw feature labels outside the chart
      textPainter.text = TextSpan(
        text: feature,
        style: TextStyle(
          color: labelColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      textPainter.layout();

      final labelRadius = radius + 20; // Position labels outside the chart
      final labelX = centerX + labelRadius * cos(currentAngle);
      final labelY = centerY + labelRadius * sin(currentAngle);

      canvas.save();
      canvas.translate(labelX, labelY);

      // Flip text on the left side to be upright
      if (currentAngle > pi / 2 && currentAngle < 3 * pi / 2) {
      }

      // canvas.rotate(rotationAngle);
      canvas.rotate(labelAngle[index]);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    });

    // 4. Draw the data graph (path, fill, and dots)
    final path = Path();

    final graphFillPaint = Paint()
      ..color = chartFillColor
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = dotColor ?? chartBorderColor
      ..style = PaintingStyle.fill;

    const dotRadius = 4.0;

    final graphOutlinePaint = Paint()
      ..color = chartBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    data.asMap().forEach((index, value) {
      final scaledValue = radius * value / ticks.last;
      final currentAngle = angleStep * index - pi / 2;
      final x = centerX + scaledValue * cos(currentAngle);
      final y = centerY + scaledValue * sin(currentAngle);
      final dataPointOffset = Offset(x, y);

      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      // Draw the solid dot at the data point.
      canvas.drawCircle(dataPointOffset, dotRadius, dotPaint);
    });

    path.close();
    canvas.drawPath(path, graphFillPaint);
    canvas.drawPath(path, graphOutlinePaint);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    // Repaint if any of the data changes
    return oldDelegate.data != data ||
        oldDelegate.features != features ||
        oldDelegate.ticks != ticks;
  }
}
