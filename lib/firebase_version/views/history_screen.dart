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

  List<PengeluaranModelFirebase> allPengeluaran = [];
  List<PemasukanModelFirebase> allPemasukan = [];

  DateTime parseTanggal(String raw) {
    try {
      return DateFormat("d MMMM yyyy", "id_ID").parse(raw);
    } catch (e) {
      return DateTime(1900);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting("id_ID", null);
    loadData();
  }

  Future<void> loadData() async {
    allPengeluaran = await FirebaseService.getAllPengeluaran(uid);
    allPemasukan = await FirebaseService.getAllPemasukan(uid);
    setState(() {});
  }

  List<Map<String, dynamic>> gabungDanFilter(String mode) {
    DateTime now = DateTime.now();

    bool isToday(DateTime d) =>
        d.year == now.year && d.month == now.month && d.day == now.day;

    bool isThisWeek(DateTime d) {
      DateTime start = now.subtract(Duration(days: now.weekday - 1));
      DateTime end = start.add(const Duration(days: 6));
      return d.isAfter(start.subtract(const Duration(days: 1))) &&
          d.isBefore(end.add(const Duration(days: 1)));
    }

    bool isThisYear(DateTime d) => d.year == now.year;

    List<Map<String, dynamic>> all = [];

    for (var p in allPengeluaran) {
      all.add({
        "jenis": "pengeluaran",
        "tanggal": parseTanggal(p.tanggalKeluar),
        "judul": p.notesPengeluaran,
        "jumlah": p.jumlahPengeluaran,
        "kategori": p.kategoriPengeluaran,
      });
    }

    for (var m in allPemasukan) {
      all.add({
        "jenis": "pemasukan",
        "tanggal": parseTanggal(m.tanggalMasuk),
        "judul": m.notesPemasukan,
        "jumlah": m.jumlahPemasukan,
        "kategori": m.kategoriPemasukan,
      });
    }

    return all.where((item) {
      DateTime date = item["tanggal"];
      switch (mode) {
        case "today":
          return isToday(date);
        case "week":
          return isThisWeek(date);
        case "year":
          return isThisYear(date);
        default:
          return true;
      }
    }).toList()..sort((a, b) => b["tanggal"].compareTo(a["tanggal"]));
  }

  Widget buildList(String mode) {
    final items = gabungDanFilter(mode);

    if (items.isEmpty) {
      return _emptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool isIncome = item["jenis"] == "pemasukan";

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isIncome ? Colors.green[100] : Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome
                      ? _iconPemasukan(item["kategori"])
                      : _iconPengeluaran(item["kategori"]),
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["judul"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xff2E5077),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat("d MMM yyyy", "id_ID").format(item["tanggal"]),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                (isIncome ? "+ " : "- ") + item["jumlah"].toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: "Transaksi Terkini", onSearchTap: () {}),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x352F59AB), Color(0x102F59AB)],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  //padding: const EdgeInsets.all(5),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Color(0xff2E5077),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xff2E5077),
                    tabs: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Tab(text: "Hari Ini", height: 50)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Tab(text: "Minggu Ini", height: 50)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Tab(text: "Tahun Ini", height: 50)],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: TabBarView(
                  children: [
                    buildList("today"),
                    buildList("week"),
                    buildList("year"),
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

// }
