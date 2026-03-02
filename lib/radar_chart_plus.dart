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

/// Holds information about a tapped dot for showing a tooltip.
class _TooltipInfo {
  final Offset position;
  final String label;
  final double value;
  final Color color;

  const _TooltipInfo({
    required this.position,
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Visual style for the dot-tap tooltip.
///
/// Pass an instance to [RadarChartPlus.tooltipStyle] to customise the look of
/// the speech-bubble that appears when the user taps a data dot.
class RadarTooltipStyle {
  /// Width of the tooltip bubble (not including the arrow). Default: 140.
  final double width;

  /// Height of the tooltip bubble (not including the arrow). Default: 40.
  final double height;

  /// Background fill colour of the tooltip. Default: near-black.
  final Color backgroundColor;

  /// Text style applied to the label text inside the tooltip.
  /// Defaults to white, 11 sp, semi-bold.
  final TextStyle textStyle;

  /// Height of the arrow triangle that points toward the dot. Default: 8.
  final double arrowHeight;

  /// Width of the arrow base. Default: 14.
  final double arrowWidth;

  /// Corner radius of the bubble rectangle. Default: 8.
  final double borderRadius;

  /// Tooltip center alignment. Default: true.
  final bool toolTipCenterAlignment;

  const RadarTooltipStyle({
    this.width = 140.0,
    this.height = 40.0,
    this.backgroundColor = const Color(0xDD1C1C2E),
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    this.arrowHeight = 8.0,
    this.arrowWidth = 14.0,
    this.borderRadius = 8.0,
    this.toolTipCenterAlignment = true,
  });
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

  /// When true, all feature labels are drawn horizontally (no rotation).
  /// Labels are positioned outside the chart using quadrant-aware alignment
  /// so they never overlap the chart boundary.
  /// Defaults to false (labels are rotated along their spoke angle).
  final bool horizontalLabels;

  /// The amount of padding (in logical pixels) to reserve around the chart
  /// for feature labels when [horizontalLabels] is true.
  ///
  /// Increasing this value shrinks the chart radius so that long side labels
  /// fit within the widget without being clipped.
  /// Has no effect when [horizontalLabels] is false.
  /// Defaults to 0.
  final double labelPadding;

  /// The maximum number of words to display per line on a feature label.
  ///
  /// When a label contains more words than this value, the extra words
  /// are wrapped onto new lines.
  /// Set to 1 (default) for single-line labels.
  /// Useful for long labels like 'Tech & Development' — set to 2 to show
  /// two words per line.
  final int maxWordsPerLine;

  /// The text alignment for feature labels.
  ///
  /// Controls how multi-line labels are aligned when [maxWordsPerLine] causes
  /// wrapping. Defaults to [TextAlign.center].
  final TextAlign labelTextAlign;

  /// The gap (in logical pixels) between the spoke tip and the feature label
  /// when [horizontalLabels] is true.
  ///
  /// Increase this to push labels further away from the chart edge.
  /// Defaults to 4.0.
  final double labelSpacing;

  /// When true, tapping on a data dot reveals a tooltip showing the feature
  /// label and value. Tapping anywhere else dismisses the tooltip.
  /// Defaults to true.
  final bool dotTapEnabled;

  /// Visual style for the dot-tap tooltip.
  /// When null, the default [RadarTooltipStyle] is used.
  final RadarTooltipStyle? tooltipStyle;

  /// Rings Color
  /// When null, the default grey color is used.
  final Color ringsColor;

  /// Stroke width of the rings default set to 1.0
  final double strokeWidth;

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
    this.horizontalLabels = false,
    this.labelPadding = 0.0,
    this.maxWordsPerLine = 1,
    this.labelTextAlign = TextAlign.center,
    this.labelSpacing = 0,
    this.dotTapEnabled = true,
    this.tooltipStyle,
    this.ringsColor = Colors.grey,
    this.strokeWidth = 1.0,

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

  /// The currently active tooltip, or null if none is shown.
  _TooltipInfo? _activeTooltip;

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

  /// Computes the pixel position of every dot given the widget [size].
  ///
  /// Returns a flat list of [_DotPosition] covering all data-sets and all
  /// data-points within each set.
  List<_DotPosition> _computeDotPositions(Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final double effectivePadding = widget.horizontalLabels
        ? widget.labelPadding
        : 0.0;
    final radius =
        (min(centerX, centerY) - effectivePadding).clamp(0.0, double.infinity) *
        0.8;
    final angleStep = (2 * pi) / widget.labels.length;

    final result = <_DotPosition>[];
    for (final dataSet in _dataSets) {
      dataSet.data.asMap().forEach((index, value) {
        final scaledValue = radius * value / ticks.last;
        final currentAngle = angleStep * index - pi / 2;
        final x = centerX + scaledValue * cos(currentAngle);
        final y = centerY + scaledValue * sin(currentAngle);
        result.add(
          _DotPosition(
            offset: Offset(x, y),
            label: widget.labels[index],
            value: value,
            color: dataSet.dotColor ?? dataSet.borderColor,
            dataSetLabel: dataSet.label,
          ),
        );
      });
    }
    return result;
  }

  /// Hit-tests [tapPosition] against all dot positions and returns the closest
  /// dot within [hitRadius] logical pixels, or null if none matches.
  _DotPosition? _hitTest(
    Offset tapPosition,
    List<_DotPosition> dots, {
    double hitRadius = 20.0,
  }) {
    _DotPosition? best;
    double bestDist = hitRadius;
    for (final dot in dots) {
      final dist = (dot.offset - tapPosition).distance;
      if (dist < bestDist) {
        bestDist = dist;
        best = dot;
      }
    }
    return best;
  }

  void _onTapDown(TapDownDetails details, Size size) {
    final dots = _computeDotPositions(size);
    final hit = _hitTest(details.localPosition, dots);
    setState(() {
      if (hit != null) {
        _activeTooltip = _TooltipInfo(
          position: hit.offset,
          label: hit.dataSetLabel != null
              ? '${hit.dataSetLabel}: ${hit.value}'
              : hit.label,
          value: hit.value,
          color: hit.color,
        );
      } else {
        _activeTooltip = null;
      }
    });
  }

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

    final painter = RadarChartPainter(
      borderColor: widget.ringsColor,
      strokeWidth: widget.strokeWidth,
      labelColor: Theme.of(context).colorScheme.onSurface,
      ticks: ticks,
      features: widget.labels,
      dataSets: _dataSets,
      labelAngles: angles,
      labelTextStyle: widget.labelTextStyle,
      horizontalLabels: widget.horizontalLabels,
      labelPadding: widget.labelPadding,
      maxWordsPerLine: widget.maxWordsPerLine,
      labelTextAlign: widget.labelTextAlign,
      labelSpacing: widget.labelSpacing,
    );

    if (!widget.dotTapEnabled) {
      return CustomPaint(size: Size.infinite, painter: painter);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapDown: (details) => _onTapDown(details, size),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(size: Size.infinite, painter: painter),
              if (_activeTooltip != null)
                _RadarTooltip(
                  info: _activeTooltip!,
                  chartSize: size,
                  style: widget.tooltipStyle ?? const RadarTooltipStyle(),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Internal model keeping track of a dot's screen position and metadata.
class _DotPosition {
  final Offset offset;
  final String label;
  final double value;
  final Color color;
  final String? dataSetLabel;

  const _DotPosition({
    required this.offset,
    required this.label,
    required this.value,
    required this.color,
    this.dataSetLabel,
  });
}

/// A styled tooltip bubble that floats above a tapped dot.
class _RadarTooltip extends StatefulWidget {
  final _TooltipInfo info;
  final Size chartSize;
  final RadarTooltipStyle style;

  const _RadarTooltip({
    required this.info,
    required this.chartSize,
    required this.style,
  });

  @override
  State<_RadarTooltip> createState() => _RadarTooltipState();
}

class _RadarTooltipState extends State<_RadarTooltip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_RadarTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = widget.style;
    final bubbleW = st.width;
    final bubbleH = st.height;
    final arrowH = st.arrowHeight;
    const margin = 6.0;
    final labelAlignment = st.toolTipCenterAlignment;

    final dotX = widget.info.position.dx;
    final dotY = widget.info.position.dy;

    // Prefer placing the bubble above the dot (arrow points down toward it).
    // If it would clip the top edge, place it below (arrow points up).
    final bool arrowDown = dotY - bubbleH - arrowH - margin >= 0;
    final double totalH = bubbleH + arrowH;

    double left = dotX - bubbleW / 2;
    left = left.clamp(margin, widget.chartSize.width - bubbleW - margin);

    final double top = arrowDown
        ? dotY -
              totalH // bubble above dot
        : dotY; // bubble below dot

    // Arrow horizontal anchor: where the dot is relative to the bubble.
    final double arrowCenterX = (dotX - left).clamp(
      st.arrowWidth,
      bubbleW - st.arrowWidth,
    );

    return Positioned(
      left: left,
      top: top,
      child: FadeTransition(
        opacity: _fade,
        child: CustomPaint(
          painter: _TooltipBubblePainter(
            color: st.backgroundColor,
            bubbleWidth: bubbleW,
            bubbleHeight: bubbleH,
            arrowHeight: arrowH,
            arrowWidth: st.arrowWidth,
            arrowCenterX: arrowCenterX,
            radius: st.borderRadius,
            arrowDown: arrowDown,
          ),
          size: Size(bubbleW, totalH),
          child: SizedBox(
            width: bubbleW,
            height: totalH,
            child: Align(
              alignment: arrowDown
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: SizedBox(
                height: bubbleH,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: labelAlignment
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: widget.info.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(widget.info.label, style: st.textStyle, maxLines: 1),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a rounded-rectangle speech bubble with a triangular arrow.
///
/// [arrowDown] = true  → arrow points downward (bubble is above the dot)
/// [arrowDown] = false → arrow points upward  (bubble is below the dot)
class _TooltipBubblePainter extends CustomPainter {
  final Color color;
  final double bubbleWidth;
  final double bubbleHeight;
  final double arrowHeight;
  final double arrowWidth;
  final double arrowCenterX;
  final double radius;
  final bool arrowDown;

  const _TooltipBubblePainter({
    required this.color,
    required this.bubbleWidth,
    required this.bubbleHeight,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.arrowCenterX,
    required this.radius,
    required this.arrowDown,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x44000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final path = _buildPath();
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  Path _buildPath() {
    final path = Path();
    final double ax = arrowCenterX;
    final double hw = arrowWidth / 2;

    if (arrowDown) {
      // Bubble occupies [0, bubbleHeight]; arrow below it.
      final rect = Rect.fromLTWH(0, 0, bubbleWidth, bubbleHeight);
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
      // Arrow triangle pointing down
      path.moveTo(ax - hw, bubbleHeight);
      path.lineTo(ax + hw, bubbleHeight);
      path.lineTo(ax, bubbleHeight + arrowHeight);
      path.close();
    } else {
      // Arrow occupies [0, arrowHeight]; bubble below it.
      final rect = Rect.fromLTWH(0, arrowHeight, bubbleWidth, bubbleHeight);
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
      // Arrow triangle pointing up
      path.moveTo(ax - hw, arrowHeight);
      path.lineTo(ax + hw, arrowHeight);
      path.lineTo(ax, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldRepaint(_TooltipBubblePainter old) =>
      old.color != color ||
      old.bubbleWidth != bubbleWidth ||
      old.bubbleHeight != bubbleHeight ||
      old.arrowHeight != arrowHeight ||
      old.arrowWidth != arrowWidth ||
      old.arrowCenterX != arrowCenterX ||
      old.radius != radius ||
      old.arrowDown != arrowDown;
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

  /// Stroke width of the rings
  final double strokeWidth;

  /// The rotation angles for each feature label.
  final List<double> labelAngles;

  /// The text style for feature labels.
  /// If null, defaults to TextStyle(color: labelColor, fontWeight: FontWeight.bold).
  final TextStyle? labelTextStyle;

  /// When true, draws all feature labels horizontally without rotation.
  final bool horizontalLabels;

  /// The padding reserved around the chart for horizontal labels.
  /// Only applied when [horizontalLabels] is true.
  final double labelPadding;

  /// The maximum number of words per line for feature labels.
  final int maxWordsPerLine;

  /// The text alignment for feature labels.
  final TextAlign labelTextAlign;

  /// The gap between the spoke tip and the feature label.
  final double labelSpacing;

  /// Creates a [RadarChartPainter].
  RadarChartPainter({
    required this.labelColor,
    required this.borderColor,
    required this.strokeWidth,
    required this.ticks,
    required this.features,
    required this.dataSets,
    required this.labelAngles,
    this.labelTextStyle,
    this.horizontalLabels = false,
    this.labelPadding = 0.0,
    this.maxWordsPerLine = 1,
    this.labelTextAlign = TextAlign.center,
    this.labelSpacing = 4.0,
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
    // When horizontalLabels is enabled, shrink the radius by labelPadding so
    // that labels on the left/right sides always fit within the widget bounds.
    final double effectivePadding = horizontalLabels ? labelPadding : 0.0;
    final radius =
        (min(centerX, centerY) - effectivePadding).clamp(0.0, double.infinity) *
        0.8;
    // The angle between each axis (spoke).
    final angleStep = (2 * pi) / features.length;

    // 1. Draw the concentric circles (ticks) for the grid.
    final tickPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final tick in ticks) {
      final tickRadius = radius * tick / ticks.last;
      canvas.drawCircle(centerOffset, tickRadius, tickPaint);
    }

    // 2. Draw the numerical labels for each tick circle.
    final textPainter = TextPainter(
      textAlign: labelTextAlign,
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

      // Draw feature labels outside the chart.
      // Wrap label text: group words into chunks of maxWordsPerLine.
      final String wrappedLabel = _wrapLabel(feature, maxWordsPerLine);
      textPainter.text = TextSpan(
        text: wrappedLabel,
        style:
            labelTextStyle ??
            TextStyle(color: labelColor, fontWeight: FontWeight.bold),
      );
      textPainter.layout();

      final labelRadius = radius + 20; // Position labels outside the chart
      final labelX = centerX + labelRadius * cos(currentAngle);
      final labelY = centerY + labelRadius * sin(currentAngle);

      if (horizontalLabels) {
        // Draw labels horizontally with quadrant-aware alignment so they
        // sit flush outside the chart and never overlap it.
        //
        // Quadrant detection uses a small tolerance band around the axes:
        //   |cos| < 0.15 → top/bottom  → centre horizontally
        //   cos > 0      → right side  → left-align (anchor left edge at spoke tip)
        //   cos < 0      → left side   → right-align (anchor right edge at spoke tip)
        //
        // Vertical offset mirrors the same logic for sin.
        const double axisTolerance = 0.15;
        final double cosA = cos(currentAngle);
        final double sinA = sin(currentAngle);

        double dx;
        if (cosA > axisTolerance) {
          // Right quadrant: left-edge of text at spoke tip + gap
          dx = labelSpacing;
        } else if (cosA < -axisTolerance) {
          // Left quadrant: right-edge of text at spoke tip - gap
          dx = -textPainter.width - labelSpacing;
        } else {
          // Top / bottom: centre horizontally
          dx = -textPainter.width / 2;
        }

        double dy;
        if (sinA > axisTolerance) {
          // Bottom quadrant: top-edge of text at spoke tip + gap
          dy = labelSpacing;
        } else if (sinA < -axisTolerance) {
          // Top quadrant: bottom-edge of text at spoke tip - gap
          dy = -textPainter.height - labelSpacing;
        } else {
          // Left / right: centre vertically
          dy = -textPainter.height / 2;
        }

        textPainter.paint(canvas, Offset(labelX + dx, labelY + dy));
      } else {
        canvas.save();
        canvas.translate(labelX, labelY);
        canvas.rotate(labelAngles[index]);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    });

    // 4. Draw all data polygons (render in order: first in background, last on top)
    for (var dataSet in dataSets) {
      _drawDataPolygon(canvas, centerX, centerY, radius, angleStep, dataSet);
    }
  }

  /// Splits [label] into lines with at most [maxWords] real words each.
  ///
  /// A "word" is any token that contains at least one letter or digit.
  /// Pure-symbol tokens (e.g. `&`, `-`, `/`) are not counted and stay
  /// attached to the current line.
  ///
  /// Example: _wrapLabel('Tech & Development forever', 2)
  ///          → 'Tech & Development\nforever'
  String _wrapLabel(String label, int maxWords) {
    if (maxWords <= 0) return label;
    final tokens = label.split(' ');

    // Regex: at least one letter or digit → counts as a real word
    final wordPattern = RegExp(r'[a-zA-Z0-9]');

    final lines = <String>[];
    final currentLine = <String>[];
    int wordCount = 0;

    for (final token in tokens) {
      final isWord = wordPattern.hasMatch(token);
      if (isWord) {
        // Real word: flush current line if the limit is reached
        if (wordCount >= maxWords && currentLine.isNotEmpty) {
          lines.add(currentLine.join(' '));
          currentLine.clear();
          wordCount = 0;
        }
        wordCount++;
      }
      // Symbols and real words both get added to the current line
      currentLine.add(token);
    }

    if (currentLine.isNotEmpty) lines.add(currentLine.join(' '));

    return lines.join('\n');
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
