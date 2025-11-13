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
        appBar: CustomAppBar(
          title: 'Finote',
          onSearchTap: () {
            print('Search tapped');
          },
          onNotificationTap: () {
            print('Notification tapped');
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 3000,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Transaksi Terkini",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2E5077),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12),
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
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value;
                          });
                          print(dropDownValue);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

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

                  Expanded(
                    child: TabBarView(
                      children: [
                        //Pengeluaran
                        FutureBuilder(
                          future: _listPengeluaran,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.data == null ||
                                snapshot.data.isEmpty) {
                              return Column(
                                children: [
                                  Image.asset(
                                    "assets/images/EmptyNotes.png",
                                    height: 150,
                                  ),
                                  Text("Catatan belum ada"),
                                ],
                              );
                            } else {
                              final data =
                                  snapshot.data as List<PengeluaranModel>;
                              return Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String? dropDownJenis;
                                    String? dropDownKategori;
                                    final items = data[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            items.kategoriPengeluaran ==
                                                    "Makan & Minum"
                                                ? Icons.fastfood
                                                : items.kategoriPengeluaran ==
                                                      "Transportasi"
                                                ? Icons.motorcycle
                                                : items.kategoriPengeluaran ==
                                                      "Hiburan"
                                                ? Icons.sports_esports
                                                : items.kategoriPengeluaran ==
                                                      "Tagihan"
                                                ? Icons.receipt_long
                                                : items.kategoriPengeluaran ==
                                                      "Belanja"
                                                ? Icons.trolley
                                                : Icons.menu,
                                          ),
                                          title: Text(
                                            items.notesPengeluaran,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff2E5077),
                                            ),
                                          ),
                                          subtitle: Text(
                                            items.tanggalKeluar,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          trailing: Text(
                                            "Rp ${items.jumlahPengeluaran.toStringAsFixed(0)}",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 0.1,
                                          color: Colors.black,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),

                        //Pemasukan
                        FutureBuilder(
                          future: _listPemasukan,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.data == null ||
                                snapshot.data.isEmpty) {
                              return Column(
                                children: [
                                  Image.asset(
                                    "assets/images/EmptyNotes.png",
                                    height: 150,
                                  ),
                                  Text("Catatan belum ada"),
                                ],
                              );
                            } else {
                              final data =
                                  snapshot.data as List<PemasukanModel>;
                              return Container(
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final items = data[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            items.kategoriPemasukan == "Gaji"
                                                ? Icons.attach_money
                                                : items.kategoriPemasukan ==
                                                      "Bonus"
                                                ? Icons.money_rounded
                                                : items.kategoriPemasukan ==
                                                      "Hadiah"
                                                ? Icons.card_giftcard_rounded
                                                : Icons.more_horiz,
                                          ),
                                          title: Text(
                                            items.notesPemasukan,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff2E5077),
                                            ),
                                          ),
                                          subtitle: Text(
                                            items.tanggalMasuk,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          trailing: Text(
                                            "Rp ${items.jumlahPemasukan.toStringAsFixed(0)}",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 0.1,
                                          color: Colors.black,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
