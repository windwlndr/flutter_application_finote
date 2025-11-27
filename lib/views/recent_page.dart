import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pemasukan_model.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/widgets/app_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<PengeluaranModel>> _listPengeluaran;
  late Future<List<PemasukanModel>> _listPemasukan;

  String? dropDownValue;
  final List<String> listKategori = ["Hari Ini", "Bulan Ini", "Tahun Ini"];

  getDataPengeluaran() {
    _listPengeluaran = DbHelper.getAllPengeluaran();
    setState(() {});
  }

  getDataPemasukan() {
    _listPemasukan = DbHelper.getAllPemasukan();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataPengeluaran();
    getDataPemasukan();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Finote', onSearchTap: () {}),
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
              Center(
                child: Text(
                  "Transaksi Terkini",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2E5077),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // DROPDOWN
              DropdownButton(
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
                },
              ),

              SizedBox(height: 8),

              // TAB BAR
              TabBar(
                labelColor: Color(0xff2E5077),
                indicatorColor: Color(0xff2E5077),
                tabs: [
                  Tab(icon: Icon(Icons.arrow_upward), text: "Pengeluaran"),
                  Tab(icon: Icon(Icons.arrow_downward), text: "Pemasukan"),
                ],
              ),

              // TAB VIEW (HARUS FLEXIBLE HEIGHT)
              Expanded(
                child: TabBarView(
                  children: [
                    // ================== PENGELUARAN ===================
                    FutureBuilder<List<PengeluaranModel>>(
                      future: _listPengeluaran,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _emptyState();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 12),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    _iconPengeluaran(item.kategoriPengeluaran),
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
                        );
                      },
                    ),

                    // ================== PEMASUKAN ===================
                    FutureBuilder<List<PemasukanModel>>(
                      future: _listPemasukan,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _emptyState();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 12),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
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
