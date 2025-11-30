import 'package:flutter/material.dart';
import 'package:flutter_application_finote/firebase_version/models/user_firebase_model.dart';
import 'package:flutter_application_finote/firebase_version/views/login_screen_firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/manage_budget.dart';
import 'package:flutter_application_finote/firebase_version/views/monthly_plan_firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/weekly_plan_firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/yearly_plan_firebase.dart';
import 'package:flutter_application_finote/preferences/preferences_handler.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';
import 'package:flutter_application_finote/views/date_tracking_page.dart';
import 'package:flutter_application_finote/views/login_page.dart';
import 'package:flutter_application_finote/views/register_page.dart';
import 'package:flutter_application_finote/widgets/app_bar.dart';
import 'package:flutter_application_finote/widgets/card_menu.dart';
import 'package:flutter_application_finote/widgets/custom_list_tile.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilUserFirebase extends StatefulWidget {
  const ProfilUserFirebase({super.key});

  @override
  State<ProfilUserFirebase> createState() => _ProfilUserFirebaseState();
}

class _ProfilUserFirebaseState extends State<ProfilUserFirebase> {
  UserFirebaseModel? user;
  final nameC = TextEditingController();
  final emailC = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final result = await FirebaseService.getCurrentUser();
    setState(() {
      user = result;
    });
  }

  Future<void> _onEdit(UserFirebaseModel user) async {
    final editNameC = TextEditingController(text: user.username);
    final editEmailC = TextEditingController(text: user.email);
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 218, 235, 255),
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
    if (res == true) {
      await FirebaseService.updateUser(
        uid: user.uid!,
        username: editNameC.text,
        email: editEmailC.text,
      );
      await loadUser();
      Fluttertoast.showToast(msg: "Data berhasil di update");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> confirmLogout() async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 218, 235, 255),
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Ya, Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (res == true) {
      await FirebaseService.logoutUser(); // logout Firebase
      Fluttertoast.showToast(msg: "Berhasil logout");

      // Navigasi ke login, tanpa menghapus data pengguna
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreenFirebase()),
        (route) => false,
      );
    }
  }

  Future<void> _onDelete(UserFirebaseModel user) async {
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
                "Apakah anda yakin ingin menghapus data ${user.username}?",
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
      //DbHelper.deleteUser(user.id!);
      loadUser();
      Fluttertoast.showToast(msg: "Data berhasil di hapus");
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (user == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff2F59AB),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/ProfPicture.png",
                width: 120,
                height: 120,
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user?.username ?? "User",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2E5077),
                    ),
                  ),

                  IconButton(
                    onPressed: user != null ? () => _onEdit(user!) : null,
                    icon: Icon(Icons.edit, size: 20, color: Color(0xff2E5077)),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                user?.email ?? "",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CardMenu(
                    title: "Manage Pengeluaran",
                    subtitle:
                        "Atur budget berdasarkan kategori (makan, transport, belanja, dll.)",
                    icon: Icons.account_balance_wallet,
                    color: Color(0xff2E5077),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageBudgetPage(),
                        ),
                      );
                    },
                  ),
                  CardMenu(
                    title: "Kelola rencana mingguan",
                    subtitle: "Tambahkan rencana keuangan mingguan Anda",
                    icon: Icons.edit_calendar_outlined,
                    color: Color(0xff2E5077),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RencanaMingguanFirebase(),
                        ),
                      );
                    },
                  ),
                  CardMenu(
                    title: "Kelola rencana bulanan",
                    subtitle: "Tambahkan rencana keuangan bulanan Anda",
                    icon: Icons.edit_calendar,
                    color: Color(0xff2E5077),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RencanaBulananFirebase(),
                        ),
                      );
                    },
                  ),
                  CardMenu(
                    title: "Kelola rencana tahunan",
                    subtitle: "Tambahkan rencana keuangan tahunan Anda",
                    icon: Icons.edit_calendar_sharp,
                    color: Color(0xff2E5077),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RencanaTahunanFirebase(),
                        ),
                      );
                    },
                  ),

                  height(20),
                  LoginButton(
                    text: 'Keluar',
                    onPressed: () {
                      confirmLogout();
                      // PreferenceHandler.removeLogin();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return LoginScreenFirebase();
                      //     },
                      //   ),
                      // );
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
