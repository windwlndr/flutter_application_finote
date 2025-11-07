import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/views/weekly_plan.dart';
import 'package:flutter_application_finote/views/monthly_plan.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/views/yearly_plan.dart';
import 'package:flutter_application_finote/widgets/chart_section.dart';

class HomePageFinote extends StatefulWidget {
  const HomePageFinote({super.key});

  @override
  State<HomePageFinote> createState() => _HomePageFinoteState();
}

class _HomePageFinoteState extends State<HomePageFinote> {
  Map<String, List<FlSpot>> lineData = {};
  List<Map<String, dynamic>> pieData = [
    {'listKategori': 'Makan & Minum'},
    {'listKategori': 'Transportasi'},
    {'listKategori': 'Hiburan'},
    {'listKategori': 'Tagihan'},
    {'listKategori': 'Belanja'},
    {'listKategori': 'Lainnya'},
  ];

  Map<String, List<FlSpot>> lineDataPemasukan = {};
  List<Map<String, dynamic>> pieDataPemasukan = [
    {'listKategori': 'Gaji'},
    {'listKategori': 'Bonus'},
    {'listKategori': 'Hadiah'},
    {'listKategori': 'Lainnya'},
  ];

  String selectedPeriod = 'Mingguan';

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    // Ambil total pengeluaran per tanggal dari database
    final db = DbHelper();
    final totalPerTanggal = await DbHelper.getTotalPengeluaranPerTanggal();
    final totalPerKategori = await DbHelper.getTotalPengeluaranPerKategori();
    final Map<String, Color> warnaKategori = {
      'Makan & Minum': Colors.orange,
      'Transportasi': Colors.blue,
      'Hiburan': Colors.purple,
      'Tagihan': Colors.yellow,
      'Belanja': Colors.red,
      'Lainnya': Colors.green,
    };

    final totalPemasukanPerTanggal =
        await DbHelper.getTotalPemasukanPerTanggal();
    final totalPemasukanPerKategori =
        await DbHelper.getTotalPemasukanPerKategori();
    final Map<String, Color> warnaKategoriPemasukan = {
      'Gaji': Colors.orange,
      'Bonus': Colors.blue,
      'Hadiah': Colors.purple,
      'Lainnya': Colors.green,
    };

    // Ubah data tanggal -> FlSpot
    int index = 0;
    final dailySpots = totalPerTanggal.entries.map((e) {
      final spot = FlSpot(index.toDouble(), e.value);
      index++;
      return spot;
    }).toList();

    final dailySpotsPemasukan = totalPemasukanPerTanggal.entries.map((e) {
      final spot = FlSpot(index.toDouble(), e.value);
      index++;
      return spot;
    }).toList();

    setState(() {
      lineData = {'Mingguan': dailySpots};
      lineDataPemasukan = {'Mingguan': dailySpotsPemasukan};

      // Konversi total kategori ke format pieData
      pieData = totalPerKategori.entries.map((e) {
        return {
          'kategori': e.key,
          'persen': e.value,
          'color':
              warnaKategori[e.key] ??
              Colors.grey, // default abu-abu jika kategori baru
        };
      }).toList();

      pieDataPemasukan = totalPemasukanPerKategori.entries.map((e) {
        return {
          'kategoriPemasukan': e.key,
          'persenPemasukan': e.value,
          'colorPemasukan':
              warnaKategoriPemasukan[e.key] ??
              Colors.grey, // default abu-abu jika kategori baru
        };
      }).toList();

      // Normalisasi persentase
      final totalAll = pieData.fold<double>(
        0,
        (sum, item) => sum + (item['persen'] ?? 0),
      );
      if (totalAll > 0) {
        for (var item in pieData) {
          final persen = (item['persen'] ?? 0);
          item['persen'] = ((persen / totalAll) * 100).roundToDouble();
        }
      } else {
        for (var item in pieData) {
          item['persen'] = 0.0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String kategori = "Makan";
    double currentValue = 1200; // realisasi
    double targetValue = 1500; // target
    double progress = currentValue / targetValue; // hasil 0.8 = 80%

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, size: 30, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 30, color: Colors.white),
            ),
          ],
          title: const Text(
            'Finote',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Color(0xff2F59AB),
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x303E7B27), Color(0x104FD18B)],
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
                        backgroundColor: Color(0xff2f59ab),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Rencana Mingguan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
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
                        backgroundColor: Color(0xff2f59ab),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Rencana Bulanan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
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
                        backgroundColor: Color(0xff2f59ab),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Rencana Tahunan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                height(20),
                TabBar(
                  labelColor: Color(0xff2E5077),
                  indicatorColor: Color(0xff2E5077),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward),

                          Text("Pengeluaran"),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(Icons.arrow_downward),

                          Text("Pemasukan"),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 650,
                  child: TabBarView(
                    children: [
                      ChartSection(
                        chartTitle: 'Grafik Pengeluaran',
                        pieTitle: 'Persentase Pengeluaran Per Kategori',
                        lineData: lineData,
                        pieData: pieData,
                        selectedPeriod: selectedPeriod,
                        onPeriodChange: (p) =>
                            setState(() => selectedPeriod = p),
                      ),

                      ChartSection(
                        chartTitle: 'Grafik Pemasukan',
                        pieTitle: 'Persentase Pemasukan Per Kategori',
                        lineData: lineDataPemasukan,
                        pieData: pieDataPemasukan,
                        selectedPeriod: selectedPeriod,
                        onPeriodChange: (p) =>
                            setState(() => selectedPeriod = p),
                      ),

                      const SizedBox(height: 16),

                      // Budget tracking
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
                              child: const Text(
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
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 20,
                                    ),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 6),
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
                      // SingleChildScrollView(
                      //   child: Column(
                      //     children: [
                      //       // 📈 Line Chart
                      //       Container(
                      //         height: 350,
                      //         width: 360,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(16),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black26,
                      //               blurRadius: 8,
                      //               offset: Offset(0, 4),
                      //             ),
                      //           ],
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(16.0),
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 'Grafik Keuangan',
                      //                 style: const TextStyle(
                      //                   fontSize: 18,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   for (var period in [
                      //                     'Mingguan',
                      //                     'Bulanan',
                      //                     'Tahunan',
                      //                   ])
                      //                     Padding(
                      //                       padding: const EdgeInsets.symmetric(
                      //                         horizontal: 4,
                      //                       ),
                      //                       child: ChoiceChip(
                      //                         label: Text(period),
                      //                         selected:
                      //                             selectedPeriod == period,
                      //                         selectedColor: Color.fromARGB(
                      //                           255,
                      //                           65,
                      //                           143,
                      //                           206,
                      //                         ),
                      //                         labelStyle: TextStyle(
                      //                           fontSize: 14,
                      //                           color: selectedPeriod == period
                      //                               ? Colors.white
                      //                               : Colors.black,
                      //                         ),
                      //                         onSelected: (_) {
                      //                           setState(() {
                      //                             selectedPeriod = period;
                      //                           });
                      //                         },
                      //                       ),
                      //                     ),
                      //                 ],
                      //               ),

                      //               const SizedBox(height: 16),

                      //               SizedBox(
                      //                 height: 200,
                      //                 child: lineData.isEmpty
                      //                     ? const Center(
                      //                         child:
                      //                             CircularProgressIndicator(),
                      //                       )
                      //                     : LineChart(
                      //                         LineChartData(
                      //                           gridData: FlGridData(
                      //                             show: true,
                      //                           ),
                      //                           titlesData: FlTitlesData(
                      //                             bottomTitles: AxisTitles(
                      //                               sideTitles: SideTitles(
                      //                                 showTitles: true,
                      //                                 getTitlesWidget:
                      //                                     (value, meta) {
                      //                                       return Text(
                      //                                         value
                      //                                             .toInt()
                      //                                             .toString(),
                      //                                       );
                      //                                     },
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           borderData: FlBorderData(
                      //                             show: true,
                      //                           ),
                      //                           lineBarsData: [
                      //                             LineChartBarData(
                      //                               spots:
                      //                                   lineData[selectedPeriod] ??
                      //                                   [],
                      //                               isCurved: true,
                      //                               color: Colors.teal,
                      //                               barWidth: 3,
                      //                               dotData: FlDotData(
                      //                                 show: true,
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),

                      //       const SizedBox(height: 24),

                      //       // 🥧 Pie Chart
                      //       Container(
                      //         height: 275,
                      //         width: 360,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(16),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black26,
                      //               blurRadius: 8,
                      //               offset: Offset(0, 4),
                      //             ),
                      //           ],
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(16.0),
                      //           child: Column(
                      //             children: [
                      //               const Text(
                      //                 'Persentase Jenis Pengeluaran',
                      //                 style: TextStyle(
                      //                   fontSize: 18,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               const SizedBox(height: 16),
                      //               Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                   horizontal: 20,
                      //                 ),
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   children: [
                      //                     Expanded(
                      //                       flex: 3,
                      //                       child: SizedBox(
                      //                         height: 200,
                      //                         child: pieData.isEmpty
                      //                             ? const Center(
                      //                                 child:
                      //                                     CircularProgressIndicator(),
                      //                               )
                      //                             : PieChart(
                      //                                 PieChartData(
                      //                                   sections: pieData.map((
                      //                                     data,
                      //                                   ) {
                      //                                     return PieChartSectionData(
                      //                                       value:
                      //                                           (data['persen'] ??
                      //                                                   0)
                      //                                               .toDouble(),
                      //                                       color:
                      //                                           data['color'],
                      //                                       title:
                      //                                           '${data['persen']}%',
                      //                                       //radius: 60,
                      //                                       titleStyle:
                      //                                           const TextStyle(
                      //                                             color: Colors
                      //                                                 .white,
                      //                                             fontSize: 12,
                      //                                             fontWeight:
                      //                                                 FontWeight
                      //                                                     .bold,
                      //                                           ),
                      //                                     );
                      //                                   }).toList(),
                      //                                   sectionsSpace: 2,
                      //                                   centerSpaceRadius: 30,
                      //                                 ),
                      //                               ),
                      //                       ),
                      //                     ),
                      //                     width(32),

                      //                     Expanded(
                      //                       flex: 3,
                      //                       child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: pieData.map((data) {
                      //                           return Padding(
                      //                             padding:
                      //                                 const EdgeInsets.symmetric(
                      //                                   vertical: 4,
                      //                                 ),
                      //                             child: Row(
                      //                               children: [
                      //                                 Container(
                      //                                   width: 14,
                      //                                   height: 14,
                      //                                   decoration:
                      //                                       BoxDecoration(
                      //                                         color:
                      //                                             data['color'],
                      //                                         shape: BoxShape
                      //                                             .circle,
                      //                                       ),
                      //                                 ),
                      //                                 const SizedBox(width: 8),
                      //                                 Flexible(
                      //                                   child: Text(
                      //                                     data['kategori'],
                      //                                     style:
                      //                                         const TextStyle(
                      //                                           fontSize: 12,
                      //                                         ),
                      //                                     overflow: TextOverflow
                      //                                         .ellipsis,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           );
                      //                         }).toList(),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),

                      //       height(8),
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 16.0,
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               "Budget Tracking",
                      //               style: TextStyle(color: Color(0xff2E5077)),
                      //             ),
                      //             TextButton(
                      //               onPressed: () {},
                      //               child: Text(
                      //                 "Manage",
                      //                 style: TextStyle(color: Colors.blue),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),

                      //       Container(
                      //         margin: const EdgeInsets.all(6),
                      //         padding: const EdgeInsets.all(12),
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey.shade100,
                      //           borderRadius: BorderRadius.circular(16),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black26,
                      //               blurRadius: 8,
                      //               offset: const Offset(0, 4),
                      //             ),
                      //           ],
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             // Baris atas: Nama kategori + nominal
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     const Icon(
                      //                       Icons.check_circle_outline,
                      //                       size: 20,
                      //                     ),
                      //                     const SizedBox(width: 8),
                      //                     Text(
                      //                       kategori,
                      //                       style: const TextStyle(
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 Text(
                      //                   "Rp. ${currentValue.toStringAsFixed(0)}K / ${targetValue.toStringAsFixed(0)}K",
                      //                   style: const TextStyle(
                      //                     fontSize: 14,
                      //                     fontWeight: FontWeight.w500,
                      //                     color: Colors.blueAccent,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),

                      //             const SizedBox(height: 8),

                      //             // Progress bar
                      //             ClipRRect(
                      //               borderRadius: BorderRadius.circular(8),
                      //               child: LinearProgressIndicator(
                      //                 value: progress, // nilai 0.0–1.0
                      //                 minHeight: 10,
                      //                 backgroundColor: Colors.grey.shade300,
                      //                 color: Colors.blue.shade800,
                      //               ),
                      //             ),

                      //             const SizedBox(height: 6),

                      //             // Persentase di bawah progress bar
                      //             Text(
                      //               "${(progress * 100).toStringAsFixed(0)}%",
                      //               style: const TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w500,
                      //                 color: Colors.grey,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
