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
              dotColor: Color(0xFF8072F3),
              chartBorderColor: Color(0xFF8072F3),
              chartFillColor: Color(0x668072F3),
              ticks: [1, 2, 3, 4, 5,6],
              features: ['AA', 'BB', 'CC', 'DD', 'EE','FF'],
              data: [1,2,3,4,5,6],
            ),
          ),
        )
    );
  }
}