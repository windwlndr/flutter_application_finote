import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_finote/firebase_version/models/pemasukan_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/models/pengeluaran_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';
import 'package:flutter_application_finote/widgets/app_bar.dart';

class HistoryScreenFirebase extends StatefulWidget {
  const HistoryScreenFirebase({super.key});

  @override
  State<HistoryScreenFirebase> createState() => _HistoryScreenFirebaseState();
}

class _HistoryScreenFirebaseState extends State<HistoryScreenFirebase> {
  String uid = FirebaseService.auth.currentUser!.uid;

  String? dropDownValue;
  final List<String> listKategori = ["Hari Ini", "Bulan Ini", "Tahun Ini"];

  List<PengeluaranModelFirebase> allPengeluaran = [];
  List<PengeluaranModelFirebase> filteredPengeluaran = [];

  List<PemasukanModelFirebase> allPemasukan = [];
  List<PemasukanModelFirebase> filteredPemasukan = [];

  DateTime parseTanggal(String raw) {
    try {
      return DateFormat("d MMMM yyyy", "id_ID").parse(raw);
    } catch (e) {
      print("ERROR PARSING TANGGAL: $raw");
      return DateTime(1900);
    }
  }

  Future<void> loadData() async {
    allPengeluaran = await FirebaseService.getAllPengeluaran(uid);
    allPemasukan = await FirebaseService.getAllPemasukan(uid);

    // default: tampilkan semua
    filteredPengeluaran = List.from(allPengeluaran);
    filteredPemasukan = List.from(allPemasukan);

    setState(() {});
  }

  void filterData() {
    DateTime now = DateTime.now();

    bool isSameDay(DateTime d1, DateTime d2) =>
        d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

    bool isSameMonth(DateTime d1, DateTime d2) =>
        d1.year == d2.year && d1.month == d2.month;

    bool isSameYear(DateTime d1, DateTime d2) => d1.year == d2.year;

    filteredPengeluaran = allPengeluaran.where((item) {
      DateTime date = parseTanggal(item.tanggalKeluar);

      switch (dropDownValue) {
        case "Hari Ini":
          return isSameDay(date, now);
        case "Bulan Ini":
          return isSameMonth(date, now);
        case "Tahun Ini":
          return isSameYear(date, now);
        default:
          return true;
      }
    }).toList();

    filteredPemasukan = allPemasukan.where((item) {
      DateTime date = parseTanggal(item.tanggalMasuk);

      switch (dropDownValue) {
        case "Hari Ini":
          return isSameDay(date, now);
        case "Bulan Ini":
          return isSameMonth(date, now);
        case "Tahun Ini":
          return isSameYear(date, now);
        default:
          return true;
      }
    }).toList();

    setState(() {});
  }

  // getDataPengeluaran() async {
  //   _listPengeluaran = FirebaseService.getAllPengeluaran(uid);
  //   final data = await _listPengeluaran;
  //   print("DEBUG: Jumlah pengeluaran: ${data.length}");
  //   setState(() {});
  // }

  // getDataPemasukan() async {
  //   _listPemasukan = FirebaseService.getAllPemasukan(uid);
  //   final data = await _listPemasukan;
  //   print("DEBUG: Jumlah pemasukan: ${data.length}");
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    loadData();
    // getDataPengeluaran();
    // getDataPemasukan();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Transaksi Terkini', onSearchTap: () {}),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x352F59AB), Color(0x102F59AB)],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL
              // Center(
              //   child: Text(
              //     "Transaksi Terkini",
              //     style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xff2E5077),
              //     ),
              //   ),
              // ),

              // SizedBox(height: 16),

              // DROPDOWN
              Center(
                child: DropdownButton(
                  hint: Text(
                    "Pilih Periode",
                    style: TextStyle(
                      color: Color(0xff2E5077),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: dropDownValue,
                  items: listKategori.map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = value;
                    });
                    filterData();
                  },
                ),
              ),

              SizedBox(height: 8),

              // TAB BAR
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

              // TAB VIEW (HARUS FLEXIBLE HEIGHT)
              Expanded(
                child: TabBarView(
                  children: [
                    //PENGELUARAN
                    // FutureBuilder<List<PengeluaranModelFirebase>>(
                    //   future: _listPengeluaran,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(child: CircularProgressIndicator());
                    //     }
                    //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    //       return _emptyState();
                    //     }
                    filteredPengeluaran.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 12),
                            itemCount: filteredPengeluaran.length,
                            itemBuilder: (context, index) {
                              final item = filteredPengeluaran[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      _iconPengeluaran(
                                        item.kategoriPengeluaran,
                                      ),
                                    ),
                                    title: Text(
                                      item.notesPengeluaran,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2E5077),
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.tanggalKeluar,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    trailing: Text(
                                      "Rp ${item.jumlahPengeluaran.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 0.3),
                                ],
                              );
                            },
                          ),

                    //PEMASUKAN
                    // FutureBuilder<List<PemasukanModelFirebase>>(
                    //   future: _listPemasukan,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(child: CircularProgressIndicator());
                    //     }
                    //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    //       return _emptyState();
                    //     }
                    filteredPemasukan.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 12),
                            itemCount: filteredPemasukan.length,
                            itemBuilder: (context, index) {
                              final item = filteredPemasukan[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      _iconPemasukan(item.kategoriPemasukan),
                                    ),
                                    title: Text(
                                      item.notesPemasukan,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2E5077),
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.tanggalMasuk,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    trailing: Text(
                                      "Rp ${item.jumlahPemasukan.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 0.3),
                                ],
                              );
                            },
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

  // ICON PENGELUARAN
  IconData _iconPengeluaran(String kategori) {
    switch (kategori) {
      case "Makan & Minum":
        return Icons.fastfood;
      case "Transportasi":
        return Icons.motorcycle;
      case "Hiburan":
        return Icons.sports_esports;
      case "Tagihan":
        return Icons.receipt_long;
      case "Belanja":
        return Icons.shopping_bag;
      default:
        return Icons.menu;
    }
  }

  // ICON PEMASUKAN
  IconData _iconPemasukan(String kategori) {
    switch (kategori) {
      case "Gaji":
        return Icons.attach_money;
      case "Bonus":
        return Icons.money_rounded;
      case "Hadiah":
        return Icons.card_giftcard_rounded;
      default:
        return Icons.more_horiz;
    }
  }

  // EMPTY STATE
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/EmptyNotes.png", height: 150),
          SizedBox(height: 12),
          Text("Catatan belum ada"),
        ],
      ),
    );
  }
}
