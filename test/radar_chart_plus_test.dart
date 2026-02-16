import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:radar_chart_plus/radar_chart_plus.dart';

void main() {
  test('RadarChartPlus can be created', () {
    SizedBox(
      width: 400,
      height: 400,
      child: RadarChartPlus(
        ticks: [2, 4, 6, 8, 10],
        labels: [
          'Speed',
          'Power',
          'Defense',
          'Agility',
          'Intelligence',
          'Stamina',
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
    );
  });
}
