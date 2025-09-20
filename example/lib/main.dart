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
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 200,
            child: RadarChartCustomPaint(
              chartBorderColor:,
              chartFillColor:,
              data: [],
              features: [],
              ticks: [],
            ),
          ),
        )
    );
  }
}