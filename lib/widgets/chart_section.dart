import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartSection extends StatelessWidget {
  final String chartTitle;
  final String pieTitle;
  final Map<String, List<FlSpot>> lineData;
  final List<Map<String, dynamic>> pieData;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChange;

  const ChartSection({
    super.key,
    required this.chartTitle,
    required this.pieTitle,
    required this.lineData,
    required this.pieData,
    required this.selectedPeriod,
    required this.onPeriodChange,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 📈 Line Chart
          Container(
            height: 350,
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    chartTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var period in ['Mingguan', 'Bulanan', 'Tahunan'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(period),
                            selected: selectedPeriod == period,
                            selectedColor: const Color(0xFF418FCE),
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: selectedPeriod == period
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSelected: (_) => onPeriodChange(period),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: lineData.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : LineChart(
                            LineChartData(
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) =>
                                        Text(value.toInt().toString()),
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: lineData[selectedPeriod] ?? [],
                                  isCurved: true,
                                  color: Colors.teal,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🥧 Pie Chart
          Container(
            height: 275,
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    pieTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 200,
                          child: pieData.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : PieChart(
                                  PieChartData(
                                    sections: pieData.map((data) {
                                      return PieChartSectionData(
                                        value: (data['persen'] ?? 0).toDouble(),
                                        color: data['color'],
                                        title: '${data['persen']}%',
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList(),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 30,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pieData.map((data) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: data['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      data['kategori'],
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
