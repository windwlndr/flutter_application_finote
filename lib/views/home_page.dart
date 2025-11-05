import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/views/weekly_plan.dart';
import 'package:flutter_application_finote/views/monthly_plan.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/views/yearly_plan.dart';

class HomePageFinote extends StatefulWidget {
  const HomePageFinote({super.key});

  @override
  State<HomePageFinote> createState() => _HomePageFinoteState();
}

class _HomePageFinoteState extends State<HomePageFinote> {
  Map<String, List<FlSpot>> lineData = {};
  List<Map<String, dynamic>> pieData = [];
  String selectedPeriod = 'Harian';

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    // Ambil total pengeluaran per tanggal dari database
    final totalPerTanggal = await DbHelper.getTotalPengeluaranPerTanggal();
    final totalPerKategori = await DbHelper.getTotalPengeluaranPerKategori();

    // Ubah data tanggal -> FlSpot
    int index = 0;
    final dailySpots = totalPerTanggal.entries.map((e) {
      final spot = FlSpot(index.toDouble(), e.value);
      index++;
      return spot;
    }).toList();

    // Simpan ke lineData (sementara hanya 'Harian')
    setState(() {
      lineData = {'Harian': dailySpots};

      // Konversi total kategori ke format pieData
      pieData = totalPerKategori.entries.map((e) {
        return {
          'kategori': e.key,
          'persen': e.value, // nanti diubah ke persen
          'color': Colors.primaries[pieData.length % Colors.primaries.length],
        };
      }).toList();

      // Normalisasi persentase
      final totalAll = pieData.fold<double>(
        0,
        (sum, item) => sum + item['persen'],
      );
      for (var item in pieData) {
        item['persen'] = (item['persen'] / totalAll * 100).roundToDouble();
      }
    });
  }

  // String selectedPeriod = 'Mingguan';

  // // Dummy data
  // final Map<String, List<FlSpot>> lineData = {
  //   'Mingguan': [
  //     FlSpot(0, 50),
  //     FlSpot(1, 70),
  //     FlSpot(2, 40),
  //     FlSpot(3, 90),
  //     FlSpot(4, 60),
  //     FlSpot(5, 100),
  //     FlSpot(6, 80),
  //   ],
  //   'Bulanan': [
  //     FlSpot(0, 400),
  //     FlSpot(1, 600),
  //     FlSpot(2, 550),
  //     FlSpot(3, 700),
  //     FlSpot(4, 800),
  //   ],
  //   'Tahunan': [
  //     FlSpot(0, 5500),
  //     FlSpot(1, 6300),
  //     FlSpot(2, 7200),
  //     FlSpot(3, 8100),
  //   ],
  // };

  // final List<Map<String, dynamic>> pieData = [
  //   {'kategori': 'Makanan', 'persen': 40, 'color': Colors.orange},
  //   {'kategori': 'Transportasi', 'persen': 25, 'color': Colors.blue},
  //   {'kategori': 'Hiburan', 'persen': 15, 'color': Colors.purple},
  //   {'kategori': 'Lainnya', 'persen': 20, 'color': Colors.green},
  // ];
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

      body: Container(
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RencanaMingguanPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(110, 75),
                      backgroundColor: Color(0xff9ECAD6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Rencana Mingguan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xff2E5077),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RencanaBulananPage(),
                        ),
                      );
                    },
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RencanaTahunanPage(),
                        ),
                      );
                    },
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
                color: Color(0xffE1FFBB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Grafik Keuangan',
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ChoiceChip(
                                label: Text(period),
                                selected: selectedPeriod == period,
                                selectedColor: Color(0xff9ECAD6),
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: selectedPeriod == period
                                      ? Color(0xff2E5077)
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
                        child: lineData.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : LineChart(
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

                      // SizedBox(
                      //   height: 200,
                      //   child: LineChart(
                      //     LineChartData(
                      //       gridData: FlGridData(show: true),
                      //       titlesData: FlTitlesData(
                      //         bottomTitles: AxisTitles(
                      //           sideTitles: SideTitles(
                      //             showTitles: true,
                      //             getTitlesWidget: (value, meta) {
                      //               return Text(value.toInt().toString());
                      //             },
                      //           ),
                      //         ),
                      //         leftTitles: AxisTitles(
                      //           sideTitles: SideTitles(showTitles: true),
                      //         ),
                      //       ),
                      //       borderData: FlBorderData(show: true),
                      //       lineBarsData: [
                      //         LineChartBarData(
                      //           spots: lineData[selectedPeriod]!,
                      //           isCurved: true,
                      //           color: Colors.teal,
                      //           barWidth: 3,
                      //           dotData: FlDotData(show: true),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🥧 Pie Chart
              Card(
                color: Color(0xff9ECAD6),
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
                        child: pieData.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : PieChart(
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

                      // SizedBox(
                      //   height: 200,
                      //   child: PieChart(
                      //     PieChartData(
                      //       sections: pieData.map((data) {
                      //         return PieChartSectionData(
                      //           value: data['persen'].toDouble(),
                      //           color: data['color'],
                      //           title:
                      //               '${data['kategori']}\n${data['persen']}%',
                      //           radius: 60,
                      //           titleStyle: const TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         );
                      //       }).toList(),
                      //     ),
                      //   ),
                      // ),
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
