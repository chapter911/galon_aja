import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galon_aja/helper/api.dart';
import 'package:galon_aja/helper/sharedpreferences.dart';
import 'package:galon_aja/page/home_page.dart';
import 'package:galon_aja/style/style.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (Prefs.checkData("username") == true) {
        Get.offAll(() => const HomePage());
      } else {
        setState(() {
          _isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/app_logo.png',
                scale: 3,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "GALON AJA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 50,
              ),
              _isloading
                  ? const CupertinoActivityIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _username,
                          decoration: Style().dekorasiInput(
                            "username",
                            icon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: Style().dekorasiInput(
                            "password",
                            icon: const Icon(Icons.vpn_key),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_username.text.isEmpty ||
                                  _password.text.isEmpty) {
                                Get.snackbar(
                                  "Maaf",
                                  "username / Password Anda Belum Lengkap",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red[900],
                                );
                              } else {
                                Api.postData(context, "users/login", {
                                  "username": _username.text,
                                  "password": _password.text,
                                }).then((value) {
                                  if (value!.status == "success") {
                                    Prefs()
                                        .saveString("username", _username.text);
                                    Prefs().saveInt(
                                      "is_admin",
                                      value.data![0]['is_admin'],
                                    );
                                    Get.offAll(() => const HomePage());
                                  }
                                });
                              }
                            },
                            child: const Text("L O G I N"),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
