import 'package:flutter/material.dart';
import 'package:flutter_application_finote/firebase_version/models/user_firebase_model.dart';
import 'package:flutter_application_finote/preferences/preferences_handler.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';
import 'package:flutter_application_finote/firebase_version/views/register_screen_firebase.dart';
import 'package:flutter_application_finote/widgets/buttom_navbar.dart';
import 'package:flutter_application_finote/widgets/login_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Bahas Shared Preference
class LoginScreenFirebase extends StatefulWidget {
  const LoginScreenFirebase({super.key});
  @override
  State<LoginScreenFirebase> createState() => _LoginScreenFirebaseState();
}

class _LoginScreenFirebaseState extends State<LoginScreenFirebase> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isVisibility = false;
  bool isLoading = false;
  UserFirebaseModel user = UserFirebaseModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  login() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ButtomNavbarWidgets()),
    );
  }

  final _formKey = GlobalKey<FormState>();
  SafeArea buildLayer() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              height: 600,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height(8),
                    Text("Login untuk masuk ke akun"),
                    height(16),
                    buildTitle("Email"),
                    height(8),
                    buildTextField(
                      hintText: "Masukkan email Anda",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
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

                    height(4),
                    buildTitle("Password"),
                    height(12),
                    buildTextField(
                      hintText: "Masukkan password Anda",
                      isPassword: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    height(12),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       "Forgot Password?",
                    //       style: TextStyle(
                    //         fontSize: 12,
                    //         // color: AppColor.orange,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    height(16),
                    LoginButton(
                      text: "Login",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final result = await FirebaseService.loginUser(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                              );

                              setState(() {
                                isLoading = false;
                                //user = result;
                              });

                              // contoh: simpan token kalau ada
                              if (user.uid != null) {
                                await PreferenceHandler.saveToken(user.uid!);
                              }

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ButtomNavbarWidgets(),
                                ),
                              );
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Validasi Salah"),
                                content: Text("Form tidak boleh kosong"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Batal"),
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
                    height(16),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.only(right: 8),
                    //         height: 1,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     Text(
                    //       "Or Sign In With",
                    //       // style: TextStyle(fontSize: 12, color: AppColor.gray88),
                    //     ),
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.only(left: 8),

                    //         height: 1,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // height(16),
                    // SizedBox(
                    //   height: 48,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.white,
                    //     ),
                    //     onPressed: () {
                    //       // Navigate to MeetLima screen menggunakan pushnamed
                    //       Navigator.pushNamed(context, "/meet_2");
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Image.asset(
                    //           "assets/images/Google.png",
                    //           height: 16,
                    //           width: 16,
                    //         ),
                    //         width(4),
                    //         Text("Google"),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun?",
                          // style: TextStyle(fontSize: 12, color: AppColor.gray88),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreenFirebase(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xff2f59ab),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x352F59AB), Color.fromARGB(255, 196, 228, 255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                  // color: AppColor.gray88,
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
        // Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
      ],
    );
  }
}
