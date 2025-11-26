import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pemasukan_firebase_model.dart';
import 'package:flutter_application_finote/models/pemasukan_model.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/models/pengeluaran_firebase_model.dart';
import 'package:flutter_application_finote/service/firebase.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/app_bar.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPageFirebase extends StatefulWidget {
  const CalendarPageFirebase({super.key});

  @override
  State<CalendarPageFirebase> createState() => _CalendarPageFirebaseState();
}

class _CalendarPageFirebaseState extends State<CalendarPageFirebase> {
  late Future<List<PengeluaranModelFirebase>> _listPengeluaran;
  final NotesPengeluaranC = TextEditingController();
  final TanggalKeluarC = TextEditingController();
  final JumlahPengeluaranC = TextEditingController();
  final KategoriPengeluaranC = TextEditingController();

  late Future<List<PemasukanModelFirebase>> _listPemasukan;
  final NotesPemasukanC = TextEditingController();
  final TanggalMasukC = TextEditingController();
  final JumlahPemasukanC = TextEditingController();
  final KategoriPemasukanC = TextEditingController();

  String uid = FirebaseService.auth.currentUser!.uid;

  DateTime _focusedDay = DateTime.now();
  DateTime? selectedPicked;
  String? dropDownKategori;
  final List<String> listKategori = [
    "Makan & Minum",
    "Transportasi",
    "Hiburan",
    "Tagihan",
    "Belanja",
    "Lain-lain",
  ];

  final List<String> listKategoriPemasukan = [
    "Gaji",
    "Bonus",
    "Hadiah",
    "Lain-lain",
  ];

  final List<String> listTransaksi = ["Pengeluaran", "Pemasukan"];

  getDataPengeluaran() async {
    _listPengeluaran = FirebaseService.getAllPengeluaran(uid);
    final data = await _listPengeluaran;
    print("DEBUG: Jumlah pengeluaran: ${data.length}");

    setState(() {});
  }

  getDataPemasukan() async {
    _listPemasukan = FirebaseService.getAllPemasukan(uid);
    final data = await _listPemasukan;
    print("DEBUG: Jumlah pemasukan: ${data.length}");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getDataPengeluaran();
      getDataPemasukan();
    } else {
      _listPengeluaran = Future.value([]);
      _listPemasukan = Future.value([]);
    }
  }

  Future<void> _onEdit(PengeluaranModelFirebase PengeluaranData) async {
    print(PengeluaranData.toMap());
    final editNotesPengeluaranC = TextEditingController(
      text: PengeluaranData.notesPengeluaran,
    );
    final editJumlahPengeluaranC = TextEditingController(
      text: PengeluaranData.jumlahPengeluaran.toString(),
    );

    // String? dropDownJenis;
    // DateTime selectedDate = selectedPicked ?? DateTime.now();

    // String formatedDate = DateFormat(
    //   'dd MMMM yyyy',
    //   'id_ID',
    // ).format(selectedDate);

    // String selectedKategori = PengeluaranData.kategoriPengeluaran;
    // String selectedCatatan = PengeluaranData.kategoriCatatan;

    String dropDownJenis = PengeluaranData.kategoriCatatan;
    String dropDownKategori = PengeluaranData.kategoriPengeluaran;

    DateTime selectedDate = DateFormat(
      "dd MMMM yyyy",
      "id_ID",
    ).parse(PengeluaranData.tanggalKeluar);

    final res = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 218, 235, 255),
              title: Text("Edit data Pengeluaran"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  buildTextField(
                    hintText: "Catatan",
                    controller: editNotesPengeluaranC,
                  ),

                  DropdownButton<String>(
                    hint: const Text(
                      "Pilih Jenis Catatan",
                      style: TextStyle(
                        color: Color(0xff2E5077),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: dropDownJenis,
                    isExpanded: true,
                    items: listTransaksi.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownJenis = value!;
                        dropDownKategori = ""; //reset kategori
                      });
                    },
                  ),

                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text(
                      "Pilih Kategori",
                      style: TextStyle(
                        color: Color(0xff2E5077),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: dropDownKategori,
                    items:
                        (dropDownJenis == "Pengeluaran"
                                ? listKategori
                                : listKategoriPemasukan)
                            .map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            })
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownKategori = value!;
                      });
                    },
                  ),

                  buildTextField(
                    hintText: "Jumlah Pengeluaran (Rp.)",
                    controller: editJumlahPengeluaranC,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Batal", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Simpan", style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      },
    );
    if (res == true) {
      //DateTime selectedDate = selectedPicked ?? DateTime.now();

      // String formatedDate = DateFormat(
      //   'dd MMMM yyyy',
      //   'id_ID',
      // ).format(selectedDate);
      // int jumlah = 0;
      // try {
      //   jumlah = int.parse(editJumlahPengeluaranC.text);
      // } catch (e) {
      //   Fluttertoast.showToast(msg: "Jumlah tidak valid");
      //   return;
      // }
      final updated = PengeluaranModelFirebase(
        id: PengeluaranData.id,
        notesPengeluaran: editNotesPengeluaranC.text,
        jumlahPengeluaran: int.parse(editJumlahPengeluaranC.text),
        tanggalKeluar: DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate),
        kategoriCatatan: dropDownJenis,
        kategoriPengeluaran: dropDownKategori,
      );
      await FirebaseService.updatePengeluaran(uid, updated);
      getDataPengeluaran();
      Fluttertoast.showToast(msg: "Pengeluaran berhasil di update");
    }
  }

  Future<void> _onDelete(PengeluaranModelFirebase PengeluaranData) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                "Apakah anda yakin ingin menghapus data ${PengeluaranData.notesPengeluaran}?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Jangan", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                "Ya, hapus data",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (res == true) {
      //hapus data dari firebase
      if (PengeluaranData.id == null) {
        Fluttertoast.showToast(msg: "Gagal menghapus: ID null");
        return;
      }

      await FirebaseService.deletePengeluaran(uid, PengeluaranData.id!);

      //refresh data
      getDataPengeluaran();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
  }

  Future<void> _onEditPemasukan(PemasukanModelFirebase pemasukanData) async {
    print(pemasukanData.toMap());
    final editNotesPemasukanC = TextEditingController(
      text: pemasukanData.notesPemasukan,
    );
    final editJumlahPemasukanC = TextEditingController(
      text: pemasukanData.jumlahPemasukan.toString(),
    );
    // String? dropDownJenis;
    // DateTime selectedDate = selectedPicked ?? DateTime.now();

    // String formatedDate = DateFormat('dd', 'id_ID').format(selectedDate);

    // String selectedKategori = pemasukanData.kategoriPemasukan;
    // String selectedCatatan = pemasukanData.kategoriCatatan;

    String dropDownJenis = pemasukanData.kategoriCatatan;
    String dropDownKategori = pemasukanData.kategoriPemasukan;

    DateTime selectedDate = DateFormat(
      "dd MMMM yyyy",
      "id_ID",
    ).parse(pemasukanData.tanggalMasuk);

    final res = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Edit data Pengeluaran"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  buildTextField(
                    hintText: "Catatan",
                    controller: editNotesPemasukanC,
                  ),

                  DropdownButton<String>(
                    hint: const Text(
                      "Pilih Jenis Catatan",
                      style: TextStyle(
                        color: Color(0xff2E5077),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: dropDownJenis,
                    isExpanded: true,
                    items: listTransaksi.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownJenis = value!;
                        dropDownKategori = "";
                      });
                    },
                  ),

                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text(
                      "Pilih Kategori",
                      style: TextStyle(
                        color: Color(0xff2E5077),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: dropDownKategori,
                    items:
                        (dropDownJenis == "Pemasukan"
                                ? listKategoriPemasukan
                                : listKategori)
                            .map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            })
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownKategori = value!;
                      });
                    },
                  ),

                  buildTextField(
                    hintText: "Jumlah Pemasukan (Rp.)",
                    controller: editJumlahPemasukanC,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Batal", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Simpan", style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      },
    );
    if (res == true) {
      // DateTime selectedDate = selectedPicked ?? DateTime.now();

      // String formatedDate = DateFormat(
      //   'dd MMMM yyyy',
      //   'id_ID',
      // ).format(selectedDate);
      // int jumlah = 0;
      // try {
      //   jumlah = int.parse(editJumlahPemasukanC.text);
      // } catch (e) {
      //   Fluttertoast.showToast(msg: "Jumlah tidak valid");
      //   return;
      // }
      final updated = PemasukanModelFirebase(
        id: pemasukanData.id,
        notesPemasukan: editNotesPemasukanC.text,
        jumlahPemasukan: int.parse(editJumlahPemasukanC.text),
        tanggalMasuk: DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate),
        kategoriCatatan: dropDownJenis,
        kategoriPemasukan: dropDownKategori,
      );

      await FirebaseService.updatePemasukan(uid, updated);
      getDataPemasukan();
      Fluttertoast.showToast(msg: "Pemasukan berhasil di update");
    }
  }

  Future<void> _onDeletePemasukan(PemasukanModelFirebase pemasukanData) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                "Apakah anda yakin ingin menghapus data ${pemasukanData.notesPemasukan}?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Jangan", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                "Ya, hapus data",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (res == true) {
      //hapus data dari firebase
      if (pemasukanData.id == null) {
        Fluttertoast.showToast(msg: "Gagal menghapus: ID null");
        return;
      }

      await FirebaseService.deletePemasukan(uid, pemasukanData.id!);

      //refresh data
      getDataPemasukan();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
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
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tambahkan Catatan",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2E5077),
                          ),
                        ),
                        SizedBox(height: 20),

                        TableCalendar(
                          locale: 'id_ID',
                          firstDay: DateTime.utc(2000, 1, 1),
                          lastDay: DateTime.utc(2100, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(selectedPicked, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              selectedPicked = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                        ),
                        SizedBox(height: 20),

                        LoginButton(
                          text: "Tambah Catatan",
                          onPressed: () async {
                            String? dropDownJenis;
                            String? dropDownKategori;
                            TextEditingController catatanC =
                                TextEditingController();
                            TextEditingController jumlahC =
                                TextEditingController();
                            DateTime selectedDate =
                                selectedPicked ?? DateTime.now();
                            String formattedDate = DateFormat(
                              'dd MMMM yyyy',
                              'id_ID',
                            ).format(selectedDate);

                            final bool? result = await showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    final kategoriList =
                                        dropDownJenis == "Pemasukan"
                                        ? listKategoriPemasukan
                                        : listKategori;

                                    final jumlahColor =
                                        dropDownJenis == "Pemasukan"
                                        ? Colors.green
                                        : dropDownJenis == "Pengeluaran"
                                        ? Colors.red
                                        : Colors.black;

                                    return AlertDialog(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        218,
                                        235,
                                        255,
                                      ),
                                      title: const Text("Tambah Catatan"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: catatanC,
                                            decoration: const InputDecoration(
                                              labelText: "Catatan",
                                            ),
                                          ),

                                          //Dropdown Jenis
                                          DropdownButton<String>(
                                            hint: const Text(
                                              "Pilih Jenis Catatan",
                                              style: TextStyle(
                                                color: Color(0xff2E5077),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            value: dropDownJenis,
                                            isExpanded: true,
                                            items: listTransaksi.map((
                                              String val,
                                            ) {
                                              return DropdownMenuItem(
                                                value: val,
                                                child: Text(
                                                  val,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                dropDownJenis = value;
                                                dropDownKategori = null;
                                              });
                                            },
                                          ),

                                          //Dropdown Kategori
                                          DropdownButton<String>(
                                            isExpanded: true,
                                            hint: const Text(
                                              "Pilih Kategori",
                                              style: TextStyle(
                                                color: Color(0xff2E5077),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            value: dropDownKategori,
                                            items:
                                                (dropDownJenis == "Pengeluaran"
                                                        ? listKategori
                                                        : listKategoriPemasukan)
                                                    .map((String val) {
                                                      return DropdownMenuItem(
                                                        value: val,
                                                        child: Text(
                                                          val,
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                        ),
                                                      );
                                                    })
                                                    .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                dropDownKategori = value;
                                              });
                                            },
                                          ),

                                          //Input jumlah
                                          TextField(
                                            controller: jumlahC,
                                            decoration: const InputDecoration(
                                              labelText: "Jumlah",
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                          height(8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                formattedDate,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            "Batal",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (dropDownJenis == null ||
                                                dropDownKategori == null ||
                                                jumlahC.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Data belum lengkap. Mohon lengkapi data!",
                                              );
                                              return;
                                            }
                                            // tampilkan item baru
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Catatan: ${catatanC.text}\nKategori: $dropDownKategori\nTanggal: $formattedDate',
                                                ),
                                              ),
                                            );

                                            if (dropDownJenis ==
                                                "Pengeluaran") {
                                              final PengeluaranModelFirebase
                                              dataPengeluaran =
                                                  PengeluaranModelFirebase(
                                                    notesPengeluaran:
                                                        catatanC.text,
                                                    tanggalKeluar:
                                                        formattedDate,
                                                    jumlahPengeluaran:
                                                        int.parse(jumlahC.text),
                                                    kategoriCatatan:
                                                        dropDownJenis!,

                                                    kategoriPengeluaran:
                                                        dropDownKategori!,
                                                  );

                                              await FirebaseService.insertPengeluaran(
                                                uid!,
                                                dataPengeluaran,
                                              ).then((value) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Data berhasil ditambahkan",
                                                );
                                              });
                                            } else if (dropDownJenis ==
                                                "Pemasukan") {
                                              final PemasukanModelFirebase
                                              dataPemasukan =
                                                  PemasukanModelFirebase(
                                                    notesPemasukan:
                                                        catatanC.text,
                                                    tanggalMasuk: formattedDate,
                                                    jumlahPemasukan: int.parse(
                                                      jumlahC.text,
                                                    ),
                                                    kategoriCatatan:
                                                        dropDownJenis!,

                                                    kategoriPemasukan:
                                                        dropDownKategori!,
                                                  );

                                              await FirebaseService.insertPemasukan(
                                                uid!,
                                                dataPemasukan,
                                              ).then((value) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Data berhasil ditambahkan",
                                                );
                                              });
                                            }

                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            "Simpan",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                            if (result == true) {
                              setState(() {
                                getDataPengeluaran();
                                getDataPemasukan();
                              });
                            }
                          },
                        ),
                        height(8),
                      ],
                    ),
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
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
                  ),
                ),
              ];
            },

            body: TabBarView(
              children: [
                //Pengeluaran
                FutureBuilder(
                  future: _listPengeluaran,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.data == null || snapshot.data.isEmpty) {
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
                          snapshot.data as List<PengeluaranModelFirebase>;
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
                                    items.kategoriPengeluaran == "Makan & Minum"
                                        ? Icons.fastfood
                                        : items.kategoriPengeluaran ==
                                              "Transportasi"
                                        ? Icons.motorcycle
                                        : items.kategoriPengeluaran == "Hiburan"
                                        ? Icons.sports_esports
                                        : items.kategoriPengeluaran == "Tagihan"
                                        ? Icons.receipt_long
                                        : items.kategoriPengeluaran == "Belanja"
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
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      width(8),
                                      Text(
                                        items.tanggalKeluar,
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _onEdit(items);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _onDelete(items);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(thickness: 0.1, color: Colors.black),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.data == null || snapshot.data.isEmpty) {
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
                          snapshot.data as List<PemasukanModelFirebase>;
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
                                        : items.kategoriPemasukan == "Bonus"
                                        ? Icons.money_rounded
                                        : items.kategoriPemasukan == "Hadiah"
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
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      width(8),
                                      Text(
                                        items.tanggalMasuk,
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _onEditPemasukan(items);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _onDeletePemasukan(items);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(thickness: 0.1, color: Colors.black),
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
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(oldDelegate) => false;
}

TextFormField buildTextField({
  String? hintText,
  bool isPassword = false,
  TextEditingController? controller,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
    ),
  );
}
