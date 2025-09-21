import 'dart:math';

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
        body: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(),
              InkWell(
                onTap: () {
                  // print(generateAngles(3));
                  // print(generateAngles(6));
                  // print(generateAngles(10));
                },
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: RadarChartCustomPaint(
                    dotColor: Color(0xFF8072F3),
                    chartBorderColor: Color(0xFF8072F3),
                    chartFillColor: Color(0x668072F3),
                    ticks: [2,4,6,8,10],
                    features: [
                      'AA',
                      'BB',
                      'CC',
                      'DD',
                      'EE',
                      'FF',
                      'GG',
                      'EE',
                      // 'FF',
                      // 'GG',
                    ],
                    data: [1, 2, 3, 4, 5, 6, 7, 8,],
                  ),
                ),
              ),
              // SizedBox(
              //   width: 200,
              //   height: 200,
              //   child: RadarChartCustomPaint(
              //     dotColor: Color(0xFF8072F3),
              //     chartBorderColor: Color(0xFF8072F3),
              //     chartFillColor: Color(0x668072F3),
              //     ticks: [1, 2, 3, 4, 5],
              //     features: ['AA', 'BB', 'CC', 'DD', 'EE'],
              //     data: [1, 2, 3, 4, 5],
              //   ),
              // ),
              // SizedBox(
              //   width: 200,
              //   height: 200,
              //   child: RadarChartCustomPaint(
              //     dotColor: Color(0xFF8072F3),
              //     chartBorderColor: Color(0xFF8072F3),
              //     chartFillColor: Color(0x668072F3),
              //     ticks: [1, 2, 3, 4],
              //     features: ['AA', 'BB', 'CC', 'DD'],
              //     data: [1, 2, 3, 4],
              //   ),
              // ),
              // SizedBox(
              //   width: 200,
              //   height: 200,
              //   child: RadarChartCustomPaint(
              //     dotColor: Color(0xFF8072F3),
              //     chartBorderColor: Color(0xFF8072F3),
              //     chartFillColor: Color(0x668072F3),
              //     ticks: [1, 2, 3],
              //     features: ['AA', 'BB', 'CC'],
              //     data: [1, 2, 3],
              //   ),
              // ),
              // SizedBox(
              //   width: 200,
              //   height: 200,
              //   child: RadarChartCustomPaint(
              //     dotColor: Color(0xFF8072F3),
              //     chartBorderColor: Color(0xFF8072F3),
              //     chartFillColor: Color(0x668072F3),
              //     ticks: [1, 2],
              //     features: ['AA', 'BB'],
              //     data: [1, 2],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
