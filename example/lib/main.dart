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
                width: 200,
                height: 200,
                child: RadarChartPlus(
                  dotColor: Color(0xFF8072F3),
                  chartBorderColor: Color(0xFF8072F3),
                  chartFillColor: Color(0x668072F3),
                  ticks: [2, 4, 6, 8, 10],
                  labels: ['AA', 'BB', 'CC', 'DD', 'EE', 'FF'],
                  data: [3, 2, 5, 6, 5, 9],
                ),
              ),

              SizedBox(
                width: 200,
                height: 200,
                child: RadarChartPlus(
                  dotColor: Color(0xFF8072F3),
                  chartBorderColor: Color(0xFF8072F3),
                  chartFillColor: Color(0x668072F3),
                  ticks: [2, 4, 6],
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
