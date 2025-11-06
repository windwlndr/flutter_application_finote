import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/pemasukan_model.dart';
import 'package:flutter_application_finote/models/pengeluaran.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<List<PengeluaranModel>> _listPengeluaran;
  final NotesPengeluaranC = TextEditingController();
  final TanggalKeluarC = TextEditingController();
  final JumlahPengeluaranC = TextEditingController();
  final KategoriPengeluaranC = TextEditingController();

  late Future<List<PemasukanModel>> _listPemasukan;
  final NotesPemasukanC = TextEditingController();
  final TanggalMasukC = TextEditingController();
  final JumlahPemasukanC = TextEditingController();
  final KategoriPemasukanC = TextEditingController();

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
    _listPengeluaran = DbHelper.getAllPengeluaran();
    final data = await _listPengeluaran;
    print("DEBUG: Jumlah pengeluaran: ${data.length}");
    for (var d in data) {
      print("Pengeluaran: ${d.notesPengeluaran} - ${d.kategoriPengeluaran}");
    }
    setState(() {});
  }

  getDataPemasukan() async {
    _listPemasukan = DbHelper.getAllPemasukan();
    final data = await _listPemasukan;
    print("DEBUG: Jumlah pemasukan: ${data.length}");
    for (var d in data) {
      print("Pemasukan: ${d.notesPemasukan} - ${d.kategoriPemasukan}");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataPengeluaran();
    getDataPemasukan();
  }

  Future<void> _onEdit(PengeluaranModel Pengeluaran) async {
    print(Pengeluaran.toMap());
    final editNotesPengeluaranC = TextEditingController(
      text: Pengeluaran.notesPengeluaran,
    );
    final editJumlahPengeluaranC = TextEditingController(
      text: Pengeluaran.jumlahPengeluaran.toString(),
    );
    String? dropDownJenis;
    DateTime selectedDate = selectedPicked ?? DateTime.now();

    String formatedDate = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(selectedDate);

    String selectedKategori = Pengeluaran.kategoriPengeluaran;
    String selectedCatatan = Pengeluaran.kategoriCatatan;

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
                        dropDownJenis = value;
                        dropDownKategori = null;
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
                        dropDownKategori = value;
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
                        formatedDate,
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
                  child: Text("Batal"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
    if (res == true) {
      DateTime selectedDate = selectedPicked ?? DateTime.now();

      String formatedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(selectedDate);
      int jumlah = 0;
      try {
        jumlah = int.parse(editJumlahPengeluaranC.text);
      } catch (e) {
        Fluttertoast.showToast(msg: "Jumlah tidak valid");
        return;
      }
      final updated = PengeluaranModel(
        id: Pengeluaran.id,
        notesPengeluaran: editNotesPengeluaranC.text,
        jumlahPengeluaran: jumlah,
        tanggalKeluar: formatedDate,
        kategoriCatatan: dropDownJenis ?? selectedCatatan,

        kategoriPengeluaran: dropDownKategori ?? selectedKategori,
      );
      await DbHelper.updatePengeluaran(updated);
      getDataPengeluaran();
      Fluttertoast.showToast(msg: "Pengeluaran berhasil di update");
    }
  }

  Future<void> _onDelete(PengeluaranModel Pengeluaran) async {
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
                "Apakah anda yakin ingin menghapus data ${Pengeluaran.notesPengeluaran}?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Jangan"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Ya, hapus data"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      await DbHelper.deletePengeluaran(Pengeluaran.id!);
      getDataPengeluaran();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
  }

  Future<void> _onEditPemasukan(PemasukanModel pemasukan) async {
    print(pemasukan.toMap());
    final editNotesPemasukanC = TextEditingController(
      text: pemasukan.notesPemasukan,
    );
    final editJumlahPemasukanC = TextEditingController(
      text: pemasukan.jumlahPemasukan.toString(),
    );
    String? dropDownJenis;
    DateTime selectedDate = selectedPicked ?? DateTime.now();

    String formatedDate = DateFormat('dd', 'id_ID').format(selectedDate);

    String selectedKategori = pemasukan.kategoriPemasukan;
    String selectedCatatan = pemasukan.kategoriCatatan;

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
                        dropDownJenis = value;
                        dropDownKategori = null;
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
                        dropDownKategori = value;
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
                        formatedDate,
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
                  child: Text("Batal"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
    if (res == true) {
      DateTime selectedDate = selectedPicked ?? DateTime.now();

      String formatedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(selectedDate);
      int jumlah = 0;
      try {
        jumlah = int.parse(editJumlahPemasukanC.text);
      } catch (e) {
        Fluttertoast.showToast(msg: "Jumlah tidak valid");
        return;
      }
      final updated = PemasukanModel(
        id: pemasukan.id,
        notesPemasukan: editNotesPemasukanC.text,
        jumlahPemasukan: jumlah,
        tanggalMasuk: formatedDate,
        kategoriCatatan: dropDownJenis ?? selectedCatatan,

        kategoriPemasukan: dropDownKategori ?? selectedKategori,
      );
      await DbHelper.updatePemasukan(updated);
      getDataPemasukan();
      Fluttertoast.showToast(msg: "Pemasukan berhasil di update");
    }
  }

  Future<void> _onDeletePemasukan(PemasukanModel pemasukan) async {
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
                "Apakah anda yakin ingin menghapus data ${pemasukan.notesPemasukan}?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Jangan"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Ya, hapus data"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      await DbHelper.deletePemasukan(pemasukan.id!);
      getDataPemasukan();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                      TextEditingController catatanC = TextEditingController();
                      TextEditingController jumlahC = TextEditingController();
                      DateTime selectedDate = selectedPicked ?? DateTime.now();
                      String formattedDate = DateFormat(
                        'dd MMMM yyyy',
                        'id_ID',
                      ).format(selectedDate);

                      final bool? result = await showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              final kategoriList = dropDownJenis == "Pemasukan"
                                  ? listKategoriPemasukan
                                  : listKategori;

                              final jumlahColor = dropDownJenis == "Pemasukan"
                                  ? Colors.green
                                  : dropDownJenis == "Pengeluaran"
                                  ? Colors.red
                                  : Colors.black;

                              return AlertDialog(
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
                                      items: listTransaksi.map((String val) {
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
                                                    style: const TextStyle(
                                                      color: Colors.black,
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
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Batal"),
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

                                      if (dropDownJenis == "Pengeluaran") {
                                        final PengeluaranModel dataPengeluaran =
                                            PengeluaranModel(
                                              notesPengeluaran: catatanC.text,
                                              tanggalKeluar: formattedDate,
                                              jumlahPengeluaran: int.parse(
                                                jumlahC.text,
                                              ),
                                              kategoriCatatan: dropDownJenis!,

                                              kategoriPengeluaran:
                                                  dropDownKategori!,
                                            );

                                        await DbHelper.insertPengeluaran(
                                          dataPengeluaran,
                                        ).then((value) {
                                          Fluttertoast.showToast(
                                            msg: "Data berhasil ditambahkan",
                                          );
                                        });
                                      } else if (dropDownJenis == "Pemasukan") {
                                        final PemasukanModel dataPemasukan =
                                            PemasukanModel(
                                              notesPemasukan: catatanC.text,
                                              tanggalMasuk: formattedDate,
                                              jumlahPemasukan: int.parse(
                                                jumlahC.text,
                                              ),
                                              kategoriCatatan: dropDownJenis!,

                                              kategoriPemasukan:
                                                  dropDownKategori!,
                                            );

                                        await DbHelper.insertPemasukan(
                                          dataPemasukan,
                                        ).then((value) {
                                          Fluttertoast.showToast(
                                            msg: "Data berhasil ditambahkan",
                                          );
                                        });
                                      }

                                      Navigator.pop(context, true);
                                    },
                                    child: const Text("Simpan"),
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
