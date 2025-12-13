library;

import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that displays a radar chart (also known as a spider chart or web chart).
///
/// This chart is useful for visualizing multivariate data in a 2D plot.
class RadarChartPlus extends StatefulWidget {
  /// A list of integers representing the concentric circles (ticks) of the chart.
  /// If not provided, it will be generated automatically based on the max value in [data].
  final List<int>? ticks;

  /// The labels for each axis of the radar chart.
  /// The length of this list must be equal to the length of the [data] list.
  final List<String> labels;

  /// The data points for each axis. The length must be between 3 and 10.
  final List<double> data;

  /// The color of the border of the main data polygon.
  final Color chartBorderColor;

  /// The fill color of the main data polygon.
  final Color chartFillColor;

  /// The color of the dots at each data point on the chart.
  /// If null, [chartBorderColor] is used.
  final Color? dotColor;

  /// Creates a radar chart.
  const RadarChartPlus({
    super.key,
    this.ticks,
    required this.labels,
    required this.data,
    required this.chartBorderColor,
    required this.chartFillColor,
    this.dotColor,
  }) : assert(
         data.length >= 3 && data.length <= 15,
         'data length must be between 3 and 10',
       ),
       assert(
         labels.length == data.length,
         'Labels and data length should be same',
       );

  @override
  State<RadarChartPlus> createState() => _RadarChartPlusState();
}

/// The state for [RadarChartPlus].
class _RadarChartPlusState extends State<RadarChartPlus> {
  List<double> angles = [];

  @override
  void initState() {
    super.initState();
    angles.addAll(generateAngles(widget.data.length));
  }

  late List<int> ticks;

  @override
  Widget build(BuildContext context) {
    // If ticks are not provided, generate them automatically.
    if (widget.ticks == null) {
      final largest = widget.data.reduce((a, b) => a > b ? a : b).ceil();
      // Create a list of integers from 1 to the largest data value.
      ticks = List<int>.generate(largest, (i) => i + 1);
    } else {
      ticks = widget.ticks!;
    }
    return CustomPaint(
      size: Size.infinite,
      painter: RadarChartPainter(
        borderColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.5),
        labelColor: Theme.of(context).colorScheme.onSurface,
        ticks: ticks,
        features: widget.labels,
        data: widget.data,
        chartBorderColor: widget.chartBorderColor,
        chartFillColor: widget.chartFillColor,
        labelAngles: angles,
        dotColor: widget.dotColor,
      ),
    );
  }
}

/// A custom painter for drawing the radar chart.
class RadarChartPainter extends CustomPainter {
  /// The tick values for the concentric circles.
  final List<int> ticks;

  /// The labels for each axis.
  final List<String> features;

  /// The data points to be plotted on the chart.
  final List<double> data;

  /// Creates a [RadarChartPainter].
  RadarChartPainter({
    required this.labelColor,
    required this.borderColor,
    required this.ticks,
    required this.features,
    required this.data,
    required this.chartBorderColor,
    required this.chartFillColor,
    required this.labelAngles,
    this.dotColor,
  });

  /// The color for the data polygon's border.
  final Color chartBorderColor;

  /// The fill color for the data polygon.
  final Color chartFillColor;

  /// The color for the dots at each data point.
  final Color? dotColor;

  /// The color for the feature labels.
  final Color labelColor;

  /// The color for the grid lines (spokes and concentric circles).
  final Color borderColor;

  /// The rotation angles for each feature label.
  final List<double> labelAngles;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the center and radius of the chart.
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = min(centerX, centerY) * 0.8;
    // The angle between each axis (spoke).
    final angleStep = (2 * pi) / features.length;

    // 1. Draw the concentric circles (ticks) for the grid.
    final tickPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final tick in ticks) {
      final tickRadius = radius * tick / ticks.last;
      canvas.drawCircle(centerOffset, tickRadius, tickPaint);
    }

    // 2. Draw the numerical labels for each tick circle.
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (var tick in ticks) {
      final tickRadius = radius * tick / ticks.last;
      textPainter.text = TextSpan(
        text: tick.toString(),
        style: TextStyle(color: labelColor),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - (textPainter.width / 2) + 6,
          centerY - (tickRadius - textPainter.height / 2) - 5,
        ),
      );
    }

    // 3. Draw the radial spokes and their corresponding feature labels.
    final featureLinePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    features.asMap().forEach((index, feature) {
      final currentAngle = angleStep * index - pi / 2; // Start from the top.
      final x = centerX + radius * cos(currentAngle);
      final y = centerY + radius * sin(currentAngle);
      final featureOffset = Offset(x, y);
      canvas.drawLine(centerOffset, featureOffset, featureLinePaint);

      // Draw feature labels outside the chart
      textPainter.text = TextSpan(
        text: feature,
        style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),
      );
      textPainter.layout();

      final labelRadius = radius + 20; // Position labels outside the chart
      final labelX = centerX + labelRadius * cos(currentAngle);
      final labelY = centerY + labelRadius * sin(currentAngle);

      canvas.save();
      canvas.translate(labelX, labelY);

      // Flip text on the left side to be upright
      if (currentAngle > pi / 2 && currentAngle < 3 * pi / 2) {}

      canvas.rotate(labelAngles[index]);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    });

    // 4. Draw the data polygon.
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
      // Scale the data value to the chart's radius.
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
      // Draw a solid dot at the data point.
      canvas.drawCircle(dataPointOffset, dotRadius, dotPaint);
    });

    path.close();

    // Fill the data polygon and then draw its outline.
    canvas.drawPath(path, graphFillPaint);
    canvas.drawPath(path, graphOutlinePaint);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    // Repaint if data, features, or ticks change.
    return oldDelegate.data != data ||
        oldDelegate.features != features ||
        oldDelegate.ticks != ticks;
  }
}

List<double> generateAngles(int length) {
  List<double> rotations = [];

  for (int i = 0; i < length; i++) {
    double angle = (2 * pi / length) * i;

    // Flip bottom half for readable orientation
    if (angle > pi / 2 && angle < 3 * pi / 2) {
      angle += pi;
    }

    rotations.add(angle);
  }
  return rotations;
}
