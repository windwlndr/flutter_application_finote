import 'package:flutter/material.dart';
import 'package:flutter_application_finote/widgets/custom_list_tile.dart';

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  State<ProfilUserPage> createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                    onTap: () {},
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
