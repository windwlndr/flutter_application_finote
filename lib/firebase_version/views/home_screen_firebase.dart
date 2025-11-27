import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_finote/firebase_version/models/budget_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/manage_budget.dart';
import 'package:flutter_application_finote/firebase_version/views/monthly_plan_firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/weekly_plan_firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/yearly_plan.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_finote/firebase_version/models/user_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';
import 'package:flutter_application_finote/views/monthly_plan.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/views/yearly_plan.dart';
import 'package:flutter_application_finote/widgets/app_bar.dart';
import 'package:flutter_application_finote/widgets/budget_section_widget.dart';
import 'package:flutter_application_finote/widgets/chart_section.dart';

class HomeFirebaseFinote extends StatefulWidget {
  const HomeFirebaseFinote({super.key});

  @override
  State<HomeFirebaseFinote> createState() => _HomeFirebaseFinoteState();
}

class _HomeFirebaseFinoteState extends State<HomeFirebaseFinote> {
  UserFirebaseModel? user;
  double sisaSaldo = 0;

  String formatRupiah(double number) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(number);
  }

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

  // Tambahkan di atas initState()
  Map<String, double> totalPengeluaranPerKategori = {};
  final Map<String, double> targetPengeluaranPerKategori = {
    'Makan & Minum': 1500000,
    'Transportasi': 1200000,
    'Hiburan': 1000000,
    'Tagihan': 1200000,
    'Belanja': 1000000,
    'Lainnya': 1000000,
  };

  String selectedPeriod = 'Mingguan';

  @override
  void initState() {
    super.initState();
    _loadChartData();
    loadUser();
    initializeDateFormatting('id_ID', null);
  }

  Future<void> loadUser() async {
    final result = await FirebaseService.getCurrentUser();
    setState(() {
      user = result;
    });
  }

  Future<void> _loadChartData() async {
    final uid = FirebaseService.auth.currentUser!.uid;
    //AMBIL DATA DARI FIREBASE
    final pengeluaranList = await FirebaseService.getAllPengeluaran(uid);
    final pemasukanList = await FirebaseService.getAllPemasukan(uid);

    double totalPengeluaran = 0;

    //HITUNG TOTAL PENGELUARAN PER TANGGAL
    Map<String, double> totalPerTanggal = {};
    //HITUNG TOTAL PENGELUARAN PER KATEGORI
    Map<String, double> totalPerKategori = {};
    for (var item in pengeluaranList) {
      totalPengeluaran += item.jumlahPengeluaran.toDouble();

      totalPerTanggal[item.tanggalKeluar] =
          (totalPerTanggal[item.tanggalKeluar] ?? 0) +
          item.jumlahPengeluaran.toDouble();

      totalPerKategori[item.kategoriPengeluaran] =
          (totalPerKategori[item.kategoriPengeluaran] ?? 0) +
          item.jumlahPengeluaran.toDouble();
    }

    final Map<String, Color> warnaKategori = {
      'Makan & Minum': Colors.orange,
      'Transportasi': Colors.blue,
      'Hiburan': Colors.purple,
      'Tagihan': Colors.yellow,
      'Belanja': Colors.red,
      'Lainnya': Colors.green,
    };

    double totalPemasukan = 0;

    //HITUNG TOTAL PEMASUKAN PER TANGGAL
    Map<String, double> totalPemasukanPerTanggal = {};
    //HITUNG TOTAL PEMASUKAN PER KATEGORI
    Map<String, double> totalPemasukanPerKategori = {};
    for (var item in pemasukanList) {
      totalPemasukan += item.jumlahPemasukan.toDouble();

      totalPemasukanPerTanggal[item.tanggalMasuk] =
          (totalPemasukanPerTanggal[item.tanggalMasuk] ?? 0) +
          item.jumlahPemasukan.toDouble();

      totalPemasukanPerKategori[item.kategoriPemasukan] =
          (totalPemasukanPerKategori[item.kategoriPemasukan] ?? 0) +
          item.jumlahPemasukan.toDouble();
    }
    final Map<String, Color> warnaKategoriPemasukan = {
      'Gaji': Colors.orange,
      'Bonus': Colors.blue,
      'Hadiah': Colors.purple,
      'Lainnya': Colors.green,
    };

    //hitung sisa saldo
    sisaSaldo = totalPemasukan - totalPengeluaran;

    // Ubah data tanggal -> FlSpot
    int index = 0;
    final dailySpots = totalPerTanggal.entries.map((e) {
      final spot = FlSpot(index.toDouble(), e.value);
      index++;
      return spot;
    }).toList();

    index = 0; //reset index
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
          'kategori': e.key,
          'persen': e.value,
          'color': warnaKategoriPemasukan[e.key] ?? Colors.grey,
        };
      }).toList();

      // Normalisasi persentase Pengeluaran
      final totalAllPengeluaran = pieData.fold<double>(
        0,
        (sum, item) => sum + (item['persen'] ?? 0),
      );
      if (totalAllPengeluaran > 0) {
        for (var item in pieData) {
          item['persen'] = ((item['persen'] / totalAllPengeluaran) * 100)
              .roundToDouble();
        }
      } else {
        for (var item in pieData) {
          item['persen'] = 0.0;
        }
      }

      // Normalisasi persentase Pemasukan
      final totalAllPemasukan = pieDataPemasukan.fold<double>(
        0,
        (sum, item) => sum + (item['persen'] ?? 0),
      );
      if (totalAllPemasukan > 0) {
        for (var item in pieDataPemasukan) {
          item['persen'] = ((item['persen'] / totalAllPemasukan) * 100)
              .roundToDouble();
        }
      } else {
        for (var item in pieDataPemasukan) {
          item['persen'] = 0.0;
        }
      }
    });

    // Menyimpan total kategori (pengeluaran) untuk tampilan lain
    totalPengeluaranPerKategori = totalPerKategori;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Finote',
          onSearchTap: () {
            print('Search tapped');
          },
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x352F59AB), Color(0x102F59AB)],
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.center,
            ),
          ),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
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
                            leading: Image.asset(
                              "assets/images/ProfPicture.png",
                            ),
                            title: Text(
                              "Halo ${user?.username ?? "User"}! Sisa saldo kamu saat ini:",
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              formatRupiah(sisaSaldo),
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
                                  builder: (context) =>
                                      RencanaMingguanFirebase(),
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
                                  builder: (context) =>
                                      RencanaBulananFirebase(),
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
                                  builder: (context) =>
                                      RencanaTahunanFirebase(),
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
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Color(0xff2E5077),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.white,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: SizedBox(
              height: 650,
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (pieData.isEmpty && lineData.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          ChartSection(
                            chartTitle: 'Grafik Pengeluaran',
                            pieTitle: 'Persentase Pengeluaran Per Kategori',
                            lineData: lineData,
                            pieData: pieData,
                            selectedPeriod: selectedPeriod,
                            onPeriodChange: (p) =>
                                setState(() => selectedPeriod = p),
                          ),

                        // Budget tracking
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Budget Tracking",
                                style: TextStyle(color: Color(0xff2E5077)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManageBudgetPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Manage",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //const SizedBox(height: 8),
                        if (totalPengeluaranPerKategori.isEmpty)
                          const Text("Belum ada data budget.")
                        else
                          Column(
                            children: [
                              StreamBuilder<List<BudgetModelFirebase>>(
                                stream: BudgetService().getBudgets(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return CircularProgressIndicator();

                                  final budgets = snapshot.data!;
                                  final budgetMap = {
                                    for (var b in budgets)
                                      b.kategori: b.targetValue,
                                  };

                                  return Column(
                                    children: totalPengeluaranPerKategori
                                        .entries
                                        .map((entry) {
                                          final kategori = entry.key;
                                          final currentValue = entry.value;

                                          final targetValue =
                                              budgetMap[kategori] ?? 1000000;

                                          final progress =
                                              (currentValue / targetValue)
                                                  .clamp(0.0, 1.0);

                                          return BudgetSectionWIdget(
                                            kategori: kategori,
                                            currentValue: currentValue / 1000,
                                            targetValue: targetValue / 1000,
                                            progress: progress,
                                          );
                                        })
                                        .toList(),
                                  );
                                },
                              ),
                            ],
                            // children: totalPengeluaranPerKategori.entries.map((
                            //   entry,
                            // ) {
                            //   final kategori = entry.key;
                            //   final currentValue = entry.value;
                            //   final targetValue =
                            //       targetPengeluaranPerKategori[kategori] ??
                            //       1000000; // default target
                            //   final progress = (currentValue / targetValue)
                            //       .clamp(0.0, 1.0);

                            //   return BudgetSectionWIdget(
                            //     kategori: kategori,
                            //     currentValue: currentValue / 1000,
                            //     targetValue: targetValue / 1000,
                            //     progress: progress,
                            //   );
                            // }).toList(),
                          ),
                      ],
                    ),
                  ),

                  if (pieDataPemasukan.isEmpty && lineDataPemasukan.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ChartSection(
                      chartTitle: 'Grafik Pemasukan',
                      pieTitle: 'Persentase Pemasukan Per Kategori',
                      lineData: lineDataPemasukan,
                      pieData: pieDataPemasukan,
                      selectedPeriod: selectedPeriod,
                      onPeriodChange: (p) => setState(() => selectedPeriod = p),
                    ),

                  //const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
