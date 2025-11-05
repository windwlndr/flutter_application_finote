import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pemasukan_model.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/list_item_widget.dart';
import 'package:flutter_application_finote/widgets/list_pengeluaran_widget.dart';

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
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x75074799), Color(0xffE1FFBB)],
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
                                  color: Color(0xff9ECAD6),
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
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                "Rp ${items.jumlahPengeluaran.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              width(8),
                                              Text(
                                                items.tanggalKeluar,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
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
                                  color: Color(0xff9ECAD6),
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
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                "Rp ${items.jumlahPemasukan.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              width(8),
                                              Text(
                                                items.tanggalMasuk,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
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
