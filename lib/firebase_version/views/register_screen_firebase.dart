import 'package:flutter/material.dart';
import 'package:flutter_application_finote/firebase_version/models/user_firebase_model.dart';
import 'package:flutter_application_finote/preferences/preferences_handler.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/login_screen_firebase.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreenFirebase extends StatefulWidget {
  const RegisterScreenFirebase({super.key});

  @override
  State<RegisterScreenFirebase> createState() => _RegisterScreenFirebaseState();
}

class _RegisterScreenFirebaseState extends State<RegisterScreenFirebase> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController konfirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisibility = false;
  bool isLoading = false;
  UserFirebaseModel user = UserFirebaseModel();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x352F59AB), Color.fromARGB(255, 196, 228, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(children: [buildLayer()]),
      ),
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              height: 650,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60, // ukuran lingkaran
                        backgroundImage: AssetImage(
                          'assets/images/Logo_Finote_updated.png',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Text(
                      "Daftar",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2f59ab),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    height(20),
                    buildTitle("Nama Lengkap"),
                    height(10),
                    height(10),
                    buildTextField(
                      hintText: "Masukkan Nama Lengkap Anda",
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama harus diisi";
                        }
                        return null;
                      },
                    ),

                    height(15),
                    buildTitle("Email"),
                    height(10),
                    buildTextField(
                      hintText: "Masukkan email Anda",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email harus diisi";
                        } else if (!value.contains('@')) {
                          return "Email tidak valid";
                        } else if (!RegExp(
                          r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
                        ).hasMatch(value)) {
                          return "Format Email tidak valid";
                        }
                        return null;
                      },
                    ),

                    height(15),

                    buildTitle("Masukkan password"),
                    height(10),
                    buildTextField(
                      isPassword: true,
                      hintText: "Masukkan password Anda",
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password harus diisi";
                        }
                        return null;
                      },
                    ),

                    // height(15),
                    // buildTitle("Konfirmasi password"),
                    // height(10),
                    // buildTextField(
                    //   isPassword: true,
                    //   hintText: "Masukkan kembali password Anda",
                    //   controller: konfirmController,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Password harus diisi";
                    //     } else if (value != passwordController.text) {
                    //       return "Password tidak sama";
                    //     }
                    //     return null;
                    //   },
                    // ),

                    //Daftar
                    height(20),

                    LoginButton(
                      text: "Daftar",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final result = await FirebaseService.registerUser(
                              email: emailController.text.trim(),
                              username: nameController.text.trim(),
                              password: passwordController.text,
                            );

                            setState(() {
                              isLoading = false;
                              user = result;
                            });

                            // contoh: simpan token kalau ada
                            if (user.uid != null) {
                              await PreferenceHandler.saveToken(user.uid!);
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreenFirebase(),
                              ),
                            );
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Validation Error"),
                                content: Text("Form tidak boleh kosong"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreenFirebase(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Color(0xff2f59ab)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
      obscureText: isPassword ? !isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

SizedBox height(double height) => SizedBox(height: height);
SizedBox width(double width) => SizedBox(width: width);

Widget buildTitle(String text) {
  return Row(
    children: [
      // Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
    ],
  );
}
