import 'package:flutter/material.dart';
import 'package:radar_chart_plus/radar_chart_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar Chart Plus',
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: RadarChartPlus(
                  /// The color of the dots on the chart.
                  dotColor: Color(0xFF8072F3),

                  /// The color of the chart border.
                  chartBorderColor: Color(0xFF8072F3),

                  /// The color of the chart fill.
                  chartFillColor: Color(0x668072F3),

                  /// The ticks to display on the chart.
                  ticks: [2, 4, 6, 8, 10],

                  /// The labels to display on the chart.
                  labels: ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'],

                  /// The data to display on the chart.
                  data: [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8],
                ),
              ),

              SizedBox(
                width: 200,
                height: 200,
                child: RadarChartPlus(
                  /// The color of the dots on the chart.
                  dotColor: Color(0xFF8072F3),

                  /// The color of the chart border.
                  chartBorderColor: Color(0xFF8072F3),

                  /// The color of the chart fill.
                  chartFillColor: Color(0x668072F3),

                  /// The ticks to display on the chart.
                  ticks: [2, 4, 6],

                  /// The labels to display on the chart.
                  labels: ['AA', 'BB', 'CC'],
                  data: [3, 2, 5],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
