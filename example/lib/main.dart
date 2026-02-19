import 'package:flutter/material.dart';
import 'package:radar_chart_plus/radar_chart_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isHorizontal = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Radar Chart Plus',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Radar Chart Plus Examples'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Example 1: Multiple Data Series (NEW FEATURE)
              InkWell(
                onTap: () {
                  setState(() {
                    isHorizontal = !isHorizontal;
                  });
                },
                child: const Text(
                  'Multiple Data Series',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),
              SizedBox(
                height: 400,
                child: RadarChartPlus(
                  labelTextStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                  ),
                  horizontalLabels: isHorizontal,
                  chartBorderColor: Colors.red,
                  ticks: [2, 4, 6, 8, 10],
                  labels: [
                    'Speed',
                    'Power',
                    'Defense',
                    'Agility',
                    'Intelligence',
                    'Tech & Development',
                  ],
                  dataSets: [
                    RadarDataSet(
                      data: [1, 2, 3, 4, 5, 6],
                      borderColor: const Color(0xFF8072F3),
                      fillColor: const Color(0x668072F3),
                      label: 'Player A',
                    ),
                    RadarDataSet(
                      data: [6, 7, 8, 9, 10, 1],
                      borderColor: const Color(0xFFFF6B6B),
                      fillColor: const Color(0x66FF6B6B),
                      label: 'Player B',
                    ),
                    RadarDataSet(
                      data: [6, 5, 4, 2, 2, 3],
                      borderColor: const Color(0xFF10FF00),
                      fillColor: const Color(0x6210FF00),
                      label: 'Player A',
                    ),
                  ],
                ),
              ),

              const Divider(height: 48),

              // Example 2: Many Axes (17 points)
              const Text(
                'Many Axes Example',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Radar chart with 17 data points',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 400,
                height: 400,
                child: RadarChartPlus(
                  /// The color of the dots on the chart.
                  dotColor: const Color(0xFF8072F3),

                  /// The color of the chart border.
                  chartBorderColor: const Color(0xFF8072F3),

                  /// The color of the chart fill.
                  chartFillColor: const Color(0x668072F3),

                  /// The ticks to display on the chart.
                  ticks: const [2, 4, 6, 8, 10],

                  /// The labels to display on the chart.
                  labels: const [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '15',
                    '16',
                    '17',
                  ],

                  /// The data to display on the chart.
                  data: const [
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7,
                    8,
                    9,
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7,
                    8,
                  ],
                ),
              ),

              const Divider(height: 48),

              // Example 3: Simple 5-Point Chart (Backward Compatibility)
              const Text(
                'Simple 5-Point Chart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Basic usage with single data series',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                height: 200,
                child: RadarChartPlus(
                  /// The color of the dots on the chart.
                  // dotColor: const Color(0xFF8072F3),
                  dotColor: const Color(0xFF8072F3),

                  /// The color of the chart border.
                  chartBorderColor: const Color(0xFF8072F3),

                  /// The color of the chart fill.
                  chartFillColor: const Color(0x668072F3),

                  /// The ticks to display on the chart.
                  ticks: const [2, 4, 6],

                  /// The labels to display on the chart.
                  labels: const ['AA', 'BB', 'CC', 'DD', 'EE'],
                  data: const [3, 2, 5, 2, 1],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
