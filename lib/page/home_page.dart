import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galon_aja/helper/api.dart';
import 'package:galon_aja/helper/constant.dart';
import 'package:galon_aja/helper/sharedpreferences.dart';
import 'package:galon_aja/login_page.dart';
import 'package:galon_aja/page/kupon_page.dart';
import 'package:galon_aja/page/karyawan_page.dart';
import 'package:galon_aja/style/style.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _search = TextEditingController();
  final TextEditingController _namaAgen = TextEditingController();
  final TextEditingController _phoneAgen = TextEditingController();
  bool _isAgree = false, _isAdmin = false;

  final List<Widget> _daftarAgen = [];

  @override
  void initState() {
    super.initState();
    _isAdmin = Prefs.readInt("is_admin") == 1 ? true : false;
    getAgen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Agen"),
        actions: [
          Visibility(
            visible: _isAdmin,
            child: IconButton(
              onPressed: () {
                Get.to(() => const KaryawanPage());
              },
              icon: const Icon(Icons.people),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  clipBehavior: Clip.antiAlias,
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red[900],
                    child: const Center(
                      child: Text(
                        "Logout ?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  content: const Text(
                    "Apakah Anda Yakin ?",
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warnaPrimary,
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Prefs().clearData();
                        Get.offAll(() => const LoginPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: TextField(
                    controller: _search,
                    decoration: Style().dekorasiInput(
                      "Nama / No. Telf Agen",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.maxFinite,
                    decoration: Style().dekorasiIconButton(),
                    child: IconButton(
                      onPressed: () {
                        getAgen();
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _daftarAgen,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _namaAgen.text = "";
            _phoneAgen.text = "";
            _isAgree = false;
          });
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setStateB) => AlertDialog(
                clipBehavior: Clip.antiAlias,
                titlePadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.all(10),
                  color: warnaPrimary,
                  child: const Center(
                    child: Text(
                      "Tambah Agen",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _namaAgen,
                      decoration: Style().dekorasiInput("Nama Agen"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _phoneAgen,
                      decoration: Style().dekorasiInput("Nomor Telefon"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CheckboxListTile(
                      title: const Text("Data ini benar"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _isAgree,
                      onChanged: (val) {
                        _isAgree = !_isAgree;
                        setState(() {});
                        setStateB(() {});
                      },
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_namaAgen.text.isEmpty ||
                          !_phoneAgen.text.isPhoneNumber) {
                        Get.snackbar(
                          "Maaf",
                          "Data yang anda inputkan belum lengkap",
                          colorText: Colors.white,
                          backgroundColor: Colors.red[900],
                        );
                      } else if (!_isAgree) {
                        Get.snackbar(
                          "Maaf",
                          "Anda belum menyatakan bahwa data ini sudah benar",
                          colorText: Colors.white,
                          backgroundColor: Colors.red[900],
                        );
                      } else {
                        Api.postData(context, "agen/insert", {
                          "nama": _namaAgen.text,
                          "phone": _phoneAgen.text,
                          "created_by": Prefs.readString("username")
                        }).then((value) {
                          if (value!.status == "success") {
                            Get.back();
                            Get.snackbar(
                              "Informasi",
                              value.message!,
                              colorText: Colors.white,
                              backgroundColor: warnaPrimary,
                            );
                            getAgen();
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warnaPrimary,
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getAgen() {
    Api.postData(context, "agen/getAgen", {
      "where": _search.text.isEmpty ? '*' : _search.text,
    }).then((value) {
      if (value!.status == "success") {
        _daftarAgen.clear();
        for (var i = 0; i < value.data!.length; i++) {
          _daftarAgen.add(InkWell(
            onTap: () {
              Get.to(() => const KuponPage(), arguments: value.data![i]);
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    color: warnaPrimary,
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        value.data![i]['nama'].toUpperCase() ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.black,
                        ),
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FractionColumnWidth(0.3),
                        1: FractionColumnWidth(0.05),
                        2: FractionColumnWidth(0.65),
                      },
                      children: [
                        TableRow(
                          children: [
                            const Text(
                              "Nomor Telefon",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value.data![i]['phone'] ?? "",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Kupon DiGunakan",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value.data![i]['is_used'] ?? "",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Kupon Tersisa",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value.data![i]['active'] ?? "",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Kupon Expired",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              value.data![i]['expired'] ?? "",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Total Kupon",
                            ),
                            const Text(
                              ":",
                            ),
                            Text(
                              "${value.data![i]['total_coupon'] ?? ""}",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
        setState(() {});
      }
    });
  }
}
