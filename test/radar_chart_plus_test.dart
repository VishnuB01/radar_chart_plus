import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:radar_chart_plus/radar_chart_plus.dart';

void main() {
  test('adds one to input values', () {
    final tester = RadarChartPlus(
      dotColor: Color(0xFF8072F3),
      chartBorderColor: Color(0xFF8072F3),
      chartFillColor: Color(0x668072F3),
      ticks: [2, 4, 6, 8, 10],
      features: ['AA', 'BB', 'CC', 'DD', 'EE', 'FF'],
      data: [3, 2, 5, 6, 5, 9],
    );
  });
}