library;

import 'dart:math';
import 'package:flutter/material.dart';

/// Represents a single data series in a radar chart.
///
/// Each [RadarDataSet] contains the data points, colors, and optional label
/// for one series that will be rendered on the radar chart.
class RadarDataSet {
  /// The data points for this series.
  /// Must have the same length as the chart's labels.
  final List<double> data;

  /// The color of the border line for this data series.
  final Color borderColor;

  /// The fill color for the polygon of this data series.
  final Color fillColor;

  /// The color of the dots at each data point.
  /// If null, [borderColor] will be used.
  final Color? dotColor;

  /// Optional label for this data series (for future legend support).
  final String? label;

  /// Creates a radar chart data series.
  ///
  /// Throws an [AssertionError] if:
  /// - [data] is empty
  /// - Any value in [data] is negative
  const RadarDataSet({
    required this.data,
    required this.borderColor,
    required this.fillColor,
    this.dotColor,
    this.label,
  }) : assert(data.length > 0, 'Data cannot be empty'),
       assert(
         data.length >= 3,
         'Data must have at least 3 points for a radar chart',
       );

  /// Creates a copy of this data set with optional new values.
  RadarDataSet copyWith({
    List<double>? data,
    Color? borderColor,
    Color? fillColor,
    Color? dotColor,
    String? label,
  }) {
    return RadarDataSet(
      data: data ?? this.data,
      borderColor: borderColor ?? this.borderColor,
      fillColor: fillColor ?? this.fillColor,
      dotColor: dotColor ?? this.dotColor,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadarDataSet &&
        other.data.length == data.length &&
        _listEquals(other.data, data) &&
        other.borderColor == borderColor &&
        other.fillColor == fillColor &&
        other.dotColor == dotColor &&
        other.label == label;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(data),
      borderColor,
      fillColor,
      dotColor,
      label,
    );
  }

  bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// A widget that displays a radar chart (also known as a spider chart or web chart).
///
/// This chart is useful for visualizing multivariate data in a 2D plot.
class RadarChartPlus extends StatefulWidget {
  /// A list of integers representing the concentric circles (ticks) of the chart.
  /// If not provided, it will be generated automatically based on the max value in [data].
  final List<int>? ticks;

  /// The labels for each axis of the radar chart.
  /// The length of this list must be equal to the length of data in each dataset.
  final List<String> labels;

  /// Multiple data series to display on the chart.
  /// Use this for rendering multiple overlapping data sets.
  /// Cannot be used together with [data], [chartBorderColor], [chartFillColor], or [dotColor].
  final List<RadarDataSet>? dataSets;

  /// [LEGACY - Single Series API]
  /// The data points for each axis. The length must be at least 3.
  /// For multiple series, use [dataSets] instead.
  final List<double>? data;

  /// [LEGACY - Single Series API]
  /// The color of the border of the main data polygon.
  /// For multiple series, use [dataSets] instead.
  final Color? chartBorderColor;

  /// [LEGACY - Single Series API]
  /// The fill color of the main data polygon.
  /// For multiple series, use [dataSets] instead.
  final Color? chartFillColor;

  /// [LEGACY - Single Series API]
  /// The color of the dots at each data point on the chart.
  /// If null, [chartBorderColor] is used.
  /// For multiple series, use [dataSets] instead.
  final Color? dotColor;

  /// The text style for feature labels.
  /// If null, defaults to TextStyle(color: labelColor, fontWeight: FontWeight.bold).
  final TextStyle? labelTextStyle;

  /// Creates a radar chart with multiple data series.
  ///
  /// Use [dataSets] for multiple series or the legacy single-series parameters
  /// ([data], [chartBorderColor], [chartFillColor]).
  ///
  /// Throws [AssertionError] if:
  /// - Both [dataSets] and [data] are provided
  /// - Neither [dataSets] nor [data] are provided
  /// - [dataSets] is empty
  /// - Any dataset has different length than [labels]
  /// - [data] length doesn't match [labels] length
  /// - [data] has fewer than 3 points
  const RadarChartPlus({
    super.key,
    this.ticks,
    required this.labels,
    this.dataSets,
    this.labelTextStyle,
    @Deprecated(
      'Use dataSets instead for better flexibility and multi-series support. '
      'This parameter will be removed in version 3.0.0.',
    )
    this.data,
    @Deprecated(
      'Use dataSets instead for better flexibility and multi-series support. '
      'This parameter will be removed in version 3.0.0.',
    )
    this.chartBorderColor,
    @Deprecated(
      'Use dataSets instead for better flexibility and multi-series support. '
      'This parameter will be removed in version 3.0.0.',
    )
    this.chartFillColor,
    @Deprecated(
      'Use dataSets instead for better flexibility and multi-series support. '
      'This parameter will be removed in version 3.0.0.',
    )
    this.dotColor,
  }) : assert(
         (dataSets != null) != (data != null),
         'Must provide either dataSets OR data (single series), not both or neither',
       ),
       assert(
         dataSets == null || dataSets.length > 0,
         'dataSets cannot be empty',
       ),
       assert(
         data == null || data.length >= 3,
         'data length must be at least 3',
       ),
       assert(
         data == null || labels.length == data.length,
         'Labels and data length must be the same',
       ),
       assert(labels.length >= 3, 'labels must have at least 3 items');

  @override
  State<RadarChartPlus> createState() => _RadarChartPlusState();
}

/// The state for [RadarChartPlus].
class _RadarChartPlusState extends State<RadarChartPlus> {
  List<double> angles = [];
  late List<RadarDataSet> _dataSets;

  @override
  void initState() {
    super.initState();
    angles.addAll(generateAngles(widget.labels.length));
    _initializeDataSets();
  }

  @override
  void didUpdateWidget(RadarChartPlus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.labels.length != widget.labels.length) {
      angles = generateAngles(widget.labels.length);
    }
    _initializeDataSets();
  }

  /// Initialize data sets from either the new API or legacy single-series API
  void _initializeDataSets() {
    if (widget.dataSets != null) {
      // New multi-series API
      _dataSets = widget.dataSets!;

      // Validate all datasets have matching length with labels
      for (var i = 0; i < _dataSets.length; i++) {
        assert(
          _dataSets[i].data.length == widget.labels.length,
          'Dataset at index $i has ${_dataSets[i].data.length} points '
          'but labels has ${widget.labels.length} items. They must match.',
        );
      }
    } else {
      // Legacy single-series API - convert to RadarDataSet
      _dataSets = [
        RadarDataSet(
          data: widget.data!,
          borderColor: widget.chartBorderColor!,
          fillColor: widget.chartFillColor!,
          dotColor: widget.dotColor,
        ),
      ];
    }
  }

  late List<int> ticks;

  @override
  Widget build(BuildContext context) {
    // If ticks are not provided, generate them automatically.
    if (widget.ticks == null) {
      // Find the largest value across all datasets
      double maxValue = 0;
      for (var dataSet in _dataSets) {
        final dataMax = dataSet.data.reduce((a, b) => a > b ? a : b);
        if (dataMax > maxValue) maxValue = dataMax;
      }
      final largest = maxValue.ceil();
      // Create a list of integers from 1 to the largest data value.
      ticks = largest > 0 ? List<int>.generate(largest, (i) => i + 1) : [1];
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
        dataSets: _dataSets,
        labelAngles: angles,
        labelTextStyle: widget.labelTextStyle,
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

  /// The data series to be plotted on the chart.
  final List<RadarDataSet> dataSets;

  /// The color for the feature labels.
  final Color labelColor;

  /// The color for the grid lines (spokes and concentric circles).
  final Color borderColor;

  /// The rotation angles for each feature label.
  final List<double> labelAngles;

  /// The text style for feature labels.
  /// If null, defaults to TextStyle(color: labelColor, fontWeight: FontWeight.bold).
  final TextStyle? labelTextStyle;

  /// Creates a [RadarChartPainter].
  RadarChartPainter({
    required this.labelColor,
    required this.borderColor,
    required this.ticks,
    required this.features,
    required this.dataSets,
    required this.labelAngles,
    this.labelTextStyle,
  }) : assert(ticks.isNotEmpty, 'ticks cannot be empty'),
       assert(features.isNotEmpty, 'features cannot be empty'),
       assert(dataSets.isNotEmpty, 'dataSets cannot be empty'),
       assert(
         labelAngles.length == features.length,
         'labelAngles must match features length',
       );

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
        style:
            labelTextStyle ??
            TextStyle(color: labelColor, fontWeight: FontWeight.bold),
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

    // 4. Draw all data polygons (render in order: first in background, last on top)
    for (var dataSet in dataSets) {
      _drawDataPolygon(canvas, centerX, centerY, radius, angleStep, dataSet);
    }
  }

  /// Draws a single data polygon for one data series
  void _drawDataPolygon(
    Canvas canvas,
    double centerX,
    double centerY,
    double radius,
    double angleStep,
    RadarDataSet dataSet,
  ) {
    final path = Path();
    final graphFillPaint = Paint()
      ..color = dataSet.fillColor
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = dataSet.dotColor ?? dataSet.borderColor
      ..style = PaintingStyle.fill;

    const dotRadius = 4.0;

    final graphOutlinePaint = Paint()
      ..color = dataSet.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    dataSet.data.asMap().forEach((index, value) {
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
    // Repaint if features, ticks, or any dataset changes.
    if (oldDelegate.features != features || oldDelegate.ticks != ticks) {
      return true;
    }

    // Check if number of datasets changed
    if (oldDelegate.dataSets.length != dataSets.length) {
      return true;
    }

    // Check if any dataset changed
    for (var i = 0; i < dataSets.length; i++) {
      if (oldDelegate.dataSets[i] != dataSets[i]) {
        return true;
      }
    }

    return false;
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
