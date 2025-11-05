import 'package:flutter/material.dart';
import 'package:flutter_application_finote/database/db_helper.dart';
import 'package:flutter_application_finote/models/user_model.dart';
import 'package:flutter_application_finote/views/date_tracking_page.dart';
import 'package:flutter_application_finote/views/login_page.dart';
import 'package:flutter_application_finote/widgets/custom_list_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  State<ProfilUserPage> createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
  UserModel? user;
  final nameC = TextEditingController();
  final emailC = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId != null) {
      final userData = await DbHelper.getUserById(userId);
      setState(() {
        user = userData;
      });
    }
  }

  Future<void> _onEdit(UserModel user) async {
    final editNameC = TextEditingController(text: user.name);
    final editEmailC = TextEditingController(text: user.email);
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit data user"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              buildTextField(hintText: "Nama", controller: editNameC),
              buildTextField(hintText: "Email", controller: editEmailC),
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
    if (res == true) {
      final updated = UserModel(
        id: user.id,
        name: editNameC.text,
        email: editEmailC.text,
      );
      DbHelper.updateUser(updated);
      loadUser();
      Fluttertoast.showToast(msg: "Data berhasil di update");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _onDelete(UserModel user) async {
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
                "Apakah anda yakin ingin menghapus data ${user.name}?",
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
              child: Text("Ya, hapus aja"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      DbHelper.deleteUser(user.id!);
      loadUser();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/ProfPicture.png",
                width: 120,
                height: 120,
              ),
              SizedBox(height: 16),

              // FutureBuilder(
              //   future: DbHelper.getAllUser(),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.data == null || snapshot.data.isEmpty) {
              //       return Column(
              //         children: [
              //           //Image.asset("assets/images/empty.png", height: 150),
              //           Text("Data belum ada"),
              //         ],
              //       );
              //     } else {
              //       final data = snapshot.data as List<UserModel>;
              //       return Expanded(
              //         child: ListView.builder(
              //           itemCount: data.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             final items = data[index];
              //             return Column(
              //               children: [
              //                 ListTile(
              //                   title: Text(items.name ?? ''),
              //                   subtitle: Text(items.email ?? ''),
              //                   trailing: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       IconButton(
              //                         onPressed: () {
              //                           _onEdit(items);
              //                         },
              //                         icon: Icon(Icons.edit),
              //                       ),
              //                       IconButton(
              //                         onPressed: () {
              //                           _onDelete(items);
              //                         },
              //                         icon: Icon(
              //                           Icons.delete,
              //                           color: Colors.red,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //       );
              //     }
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Windu Wulandari",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2E5077),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, size: 20, color: Color(0xff2E5077)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Akun personal",
                style: TextStyle(fontSize: 14, color: Color(0xff2E5077)),
              ),
              SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTileWidget(
                    title: "Pemasukan & Pengeluaran",
                    subtitle:
                        "Atur budget berdasarkan kategori (makan, transport, belanja, dll.)",
                    leadingIcon: Icons.account_balance_wallet,
                    iconColor: Color(0xff2E5077),
                    textColor: Color(0xff2E5077),
                    onTap: () {},
                  ),
                  ListTileWidget(
                    title: "Tujuan Keuangan",
                    subtitle: "Atur target tabungan dan batas pengeluaran.",
                    leadingIcon: Icons.calculate,
                    iconColor: Color(0xff2E5077),
                    textColor: Color(0xff2E5077),
                    onTap: () {},
                  ),
                  ListTileWidget(
                    title: "Notifikasi Pengingat",
                    subtitle:
                        "Atur notifikasi harian/bulanan/tahunan dan tagihan.",
                    leadingIcon: Icons.notification_add,
                    iconColor: Color(0xff2E5077),
                    textColor: Color(0xff2E5077),
                    onTap: () {},
                  ),
                  ListTileWidget(
                    title: "Keamanan Akun",
                    subtitle: "Ubah kata sandi, aktifkan PIN dan Biometrik.",
                    leadingIcon: Icons.safety_check,
                    iconColor: Color(0xff2E5077),
                    textColor: Color(0xff2E5077),
                    onTap: () {},
                  ),
                  ListTileWidget(
                    title: "Pindah Akun",
                    subtitle: "Ubah profil menjadi akun bisnis.",
                    leadingIcon: Icons.switch_account,
                    iconColor: Color(0xff2E5077),
                    textColor: Color(0xff2E5077),
                    onTap: () {},
                  ),
                  ListTileWidget(
                    title: "Logout",
                    subtitle: "Keluar dari akun Finote Anda.",
                    leadingIcon: Icons.logout,
                    iconColor: Colors.red,
                    textColor: Colors.red,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreenDay18();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
