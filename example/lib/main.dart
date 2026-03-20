import 'dart:math';
import 'package:flutter/material.dart';
import 'package:radar_chart_plus/radar_chart_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar Chart Plus',
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        brightness: Brightness.dark,
      ),
      home: DemoPage(
        isDark: _isDark,
        onToggleTheme: () => setState(() => _isDark = !_isDark),
      ),
    );
  }
}

// ─── label & color pools ───────────────────────────────────────────────────

const _labels = [
  'AAAA',
  'BBBB',
  'CCCC',
  'DDDD',
  'EEEE',
  'FFFF',
  'GGGG',
  'HHHH',
  'IIII',
  'JJJJ',
  'KKKK',
  'LLLL',
];

const _seriesColors = [
  Color(0xFF6C63FF),
  Color(0xFFFF6B9D),
  Color(0xFF43E8A0),
  Color(0xFFFFA94D),
  Color(0xFF4DBFFF),
];

List<double> makeData(int count, int seed) {
  final r = Random(seed);
  return List.generate(count, (_) {
    double value = r.nextDouble() * (10 - 1) + 1;
    return double.parse(value.toStringAsFixed(2));
  });
}

// ─── Demo Page ─────────────────────────────────────────────────────────────

class DemoPage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const DemoPage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  double _axes = 6;
  double _series = 2;
  bool _horizontalLabels = false;
  bool _customToolTip = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final axesCount = _axes.round();
    final seriesCount = _series.round();

    final labels = _labels.take(axesCount).toList();
    final dataSets = List.generate(seriesCount, (i) {
      final c = _seriesColors[i % _seriesColors.length];
      return RadarDataSet(
        label: 'S${i + 1}',
        data: makeData(axesCount, i + 1),
        borderColor: c,
        fillColor: c.withValues(alpha: 0.2),
        dotColor: c,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Radar Chart Plus',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: widget.isDark ? 'Light mode' : 'Dark mode',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Chart ──────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: RadarChartPlus(
                strokeWidth: 1.5,
                ringsColor: Colors.grey,
                key: ValueKey('$axesCount-$seriesCount'),
                ticks: const [2, 4, 6, 8, 10],
                customToolTipText: _customToolTip
                    ? (label, value, dataSetLabel) =>
                          '${dataSetLabel} ${label} = ${value.toStringAsFixed(1)} pts'
                    : null,
                labels: labels,
                dataSets: dataSets,
                dotTapEnabled: true,
                tooltipStyle: const RadarTooltipStyle(showColorIndicator: true),
                horizontalLabels: _horizontalLabels,
                maxWordsPerLine: 1,
                labelSpacing: 4,
                labelTextStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // ── Controls ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              border: Border(
                top: BorderSide(color: cs.outlineVariant, width: 1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SliderRow(
                  label: 'Axes',
                  value: _axes,
                  min: 3,
                  max: 12,
                  divisions: 9,
                  onChanged: (v) => setState(() => _axes = v),
                  color: _seriesColors[0],
                ),
                const SizedBox(height: 16),
                _SliderRow(
                  label: 'Series',
                  value: _series,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (v) => setState(() => _series = v),
                  color: _seriesColors[1],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'Horizontal Labels',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Switch(
                      value: _horizontalLabels,
                      onChanged: (v) => setState(() => _horizontalLabels = v),
                      activeColor: _seriesColors[2],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: Text(
                        'Custom Tool Tip',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Switch(
                      value: _customToolTip,
                      onChanged: (v) => setState(() => _customToolTip = v),
                      activeColor: _seriesColors[2],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Slider row component ──────────────────────────────────────────────────

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final Color color;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.2),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.12),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: min,
              max: max,
              divisions: divisions,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 24,
          child: Text(
            '${value.round()}',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
