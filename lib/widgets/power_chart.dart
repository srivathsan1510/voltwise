import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PowerChart extends StatelessWidget {
  final List<double> history;

  const PowerChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Real-Time Load (kW)", 
            style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: history.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF00E5FF),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00E5FF).withOpacity(0.2),
                    ),
                  ),
                ],
                minX: history.length > 20 ? history.length - 20.0 : 0,
                maxX: history.length > 1 ? history.length - 1.0 : 10,
                minY: 0,
                maxY: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}