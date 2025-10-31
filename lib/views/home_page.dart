import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_finote/views/register_page.dart';

class HomePageFinote extends StatefulWidget {
  const HomePageFinote({super.key});

  @override
  State<HomePageFinote> createState() => _HomePageFinoteState();
}

class _HomePageFinoteState extends State<HomePageFinote> {
  String selectedPeriod = 'Harian';


  // Dummy data
  final Map<String, List<FlSpot>> lineData = {
    'Harian': [
      FlSpot(0, 50),
      FlSpot(1, 70),
      FlSpot(2, 40),
      FlSpot(3, 90),
      FlSpot(4, 60),
      FlSpot(5, 100),
      FlSpot(6, 80),
    ],
    'Bulanan': [
      FlSpot(0, 400),
      FlSpot(1, 600),
      FlSpot(2, 550),
      FlSpot(3, 700),
      FlSpot(4, 800),
    ],
    'Tahunan': [
      FlSpot(0, 5500),
      FlSpot(1, 6300),
      FlSpot(2, 7200),
      FlSpot(3, 8100),
    ],
  };

  final List<Map<String, dynamic>> pieData = [
    {'kategori': 'Makanan', 'persen': 40, 'color': Colors.orange},
    {'kategori': 'Transportasi', 'persen': 25, 'color': Colors.blue},
    {'kategori': 'Hiburan', 'persen': 15, 'color': Colors.purple},
    {'kategori': 'Lainnya', 'persen': 20, 'color': Colors.green},
  ];
  @override
  Widget build(BuildContext context) {
    String kategori = "Makan";
    double currentValue = 1200; // realisasi
    double targetValue = 1500; // target
    double progress = currentValue / targetValue; // hasil 0.8 = 80%

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 30)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, size: 30),
          ),
        ],
        title: const Text(
          'Finote',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 16, 62, 100),
          ),
        ),
        backgroundColor: Color(0x75074799),
      ),
      
      body: 
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x75074799), Color(0xffE1FFBB)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.center,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Container(
                  width: 1200,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.asset("assets/images/ProfPicture.png"),
                    title: Text(
                      "Halo Windu! Saldo kamu saat ini:",
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      "Rp. 3.850.000",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2E5077),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(110, 75),
                      backgroundColor: Color(0xff9ECAD6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Rencana Harian",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xff2E5077),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(110, 75),
                      backgroundColor: Color(0xff9ECAD6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Rencana Bulanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xff2E5077),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(110, 75),
                      backgroundColor: Color(0xff9ECAD6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Rencana Tahunan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xff2E5077),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              height(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_upward), Text("Pengeluaran")],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_downward), Text("Pemasukan")],
                    ),
                  ),
                ],
              ),

              // 📈 Line Chart
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Grafik\nKeuangan',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                              height: 20,
                            ),
                          ),
                          for (var period in ['Harian', 'Bulanan', 'Tahunan'])
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ChoiceChip(
                                label: Text(period),
                                selected: selectedPeriod == period,
                                selectedColor: Colors.teal,
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: selectedPeriod == period
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onSelected: (_) {
                                  setState(() {
                                    selectedPeriod = period;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(value.toInt().toString());
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: lineData[selectedPeriod]!,
                                isCurved: true,
                                color: Colors.teal,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                            // lineTouchData: LineTouchData(
                            //   enabled: true,
                            //   touchTooltipData: LineTouchTooltipData(
                            //     tooltipBgColor: Colors.white,
                            //     getTooltipItems: (touchedSpots) {
                            //       return touchedSpots.map((spot) {
                            //         return LineTooltipItem(
                            //           'Rp ${spot.y.toStringAsFixed(0)}',
                            //           const TextStyle(
                            //               color: Colors.black, fontSize: 12),
                            //         );
                            //       }).toList();
                            //     },
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🥧 Pie Chart
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Persentase Jenis Pengeluaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: pieData.map((data) {
                              return PieChartSectionData(
                                value: data['persen'].toDouble(),
                                color: data['color'],
                                title:
                                    '${data['kategori']}\n${data['persen']}%',
                                radius: 60,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              height(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Budget Tracking",
                      style: TextStyle(color: Color(0xff2E5077)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Manage",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              // ListTile(
              //   leading: Image.asset(
              //     "assets/images/uv_shield_tone_up_sunscreen-min.png",
              //   ),
              //   title: Text(
              //     "Wardah UV Shield Tone Up",
              //     style: TextStyle(fontSize: 16),
              //   ),
              //   subtitle: Text("Rp. 72.500", style: TextStyle(fontSize: 12)),
              //   trailing: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(Icons.favorite),
              //       SizedBox(width: 8),
              //       Icon(Icons.trolley),
              //       SizedBox(width: 8),
              //       Icon(Icons.share),
              //     ],
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris atas: Nama kategori + nominal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              kategori,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Rp. ${currentValue.toStringAsFixed(0)}K / ${targetValue.toStringAsFixed(0)}K",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress, // nilai 0.0–1.0
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.blue.shade800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Persentase di bawah progress bar
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }
}
