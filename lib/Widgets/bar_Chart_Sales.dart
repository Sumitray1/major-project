import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSales extends StatelessWidget {
  const BarChartSales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 300,
            barGroups: [
              _buildBarGroup(0, 200),
              _buildBarGroup(1, 300),
              _buildBarGroup(2, 150),
              _buildBarGroup(3, 225),
              _buildBarGroup(4, 250),
              _buildBarGroup(5, 75),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const days = ['M', 'T', 'W', 'Th', 'F', 'S'];
                    return Text(
                      days[value.toInt()],
                      style: TextStyle(
                        color: Color(0xFF979699),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 15,
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.deepPurple.withValues(alpha: 0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
