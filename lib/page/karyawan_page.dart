import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galon_aja/helper/api.dart';
import 'package:galon_aja/helper/constant.dart';
import 'package:galon_aja/helper/format_changer.dart';
import 'package:galon_aja/helper/sharedpreferences.dart';
import 'package:galon_aja/style/style.dart';
import 'package:get/get.dart';

class KaryawanPage extends StatefulWidget {
  const KaryawanPage({super.key});

  @override
  State<KaryawanPage> createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  bool _isAgree = false;

  final List<Widget> _karyawan = [];

  int _idToko = 0, _isActive = 0;
  String _toko = "- Pilih Toko -";

  final List<String> _listToko = ["- Pilih Toko -"];
  final List<int> _listIdToko = [0];

  @override
  void initState() {
    super.initState();
    getKaryawan();
    getToko();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Karyawan"),
        actions: [
          IconButton(
            onPressed: () {
              getKaryawan();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: _karyawan,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _username.text = "";
            _nama.text = "";
            _phone.text = "";
            _password.text = "";
            _confirmation.text = "";
            _idToko = 0;
            _toko = "- Pilih Toko -";
            _isAgree = false;
          });
          dialogKaryawan(false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getKaryawan() {
    Api.getData(context, "users/karyawan").then((value) {
      if (value!.status == "success") {
        _karyawan.clear();
        for (var i = 0; i < value.data!.length; i++) {
          _karyawan.add(InkWell(
            onTap: () {
              if (Get.isSnackbarOpen) {
                Get.closeAllSnackbars();
              } else {
                setState(() {
                  _username.text = value.data![i]['username'];
                  _nama.text = value.data![i]['nama'];
                  _phone.text = value.data![i]['phone'];
                  _idToko = value.data![i]['id_toko'];
                  _toko = value.data![i]['nama_toko'];
                  _isActive = value.data![i]['is_active'];
                });
                dialogKaryawan(true);
              }
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
                        value.data![i]['username'].toUpperCase() ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: value.data![i]['is_active'] == 1
                        ? Colors.white
                        : Colors.red[200],
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
                            const Text("Phone"),
                            const Text(":"),
                            Text(
                              value.data![i]['phone'] ?? "",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text("Toko"),
                            const Text(":"),
                            Text(
                              value.data![i]['nama_toko'] ?? "",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text("Status"),
                            const Text(":"),
                            Text(
                              value.data![i]['is_active'] == 1
                                  ? "Aktif"
                                  : "Tidak Aktif",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text("Created Date"),
                            const Text(":"),
                            Text(
                              FormatChanger().tanggalIndoFromString(
                                  value.data![i]['created_date']),
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

  void dialogKaryawan(bool isUpdate) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateB) => AlertDialog(
          clipBehavior: Clip.antiAlias,
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(10),
            color: warnaPrimary,
            child: Center(
              child: Text(
                isUpdate ? "Update Karyawan" : "Tambah Karyawan",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _username,
                  readOnly: isUpdate,
                  decoration: Style().dekorasiInput("Username"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: !isUpdate,
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: Style().dekorasiInput("Password"),
                  ),
                ),
                Visibility(
                  visible: !isUpdate,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: !isUpdate,
                  child: TextField(
                    controller: _confirmation,
                    obscureText: true,
                    decoration: Style().dekorasiInput("Konfirmasi Password"),
                  ),
                ),
                Visibility(
                  visible: !isUpdate,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                TextField(
                  controller: _nama,
                  decoration: Style().dekorasiInput("Nama"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _phone,
                  decoration: Style().dekorasiInput("Nomor Telefon"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Toko : "),
                Container(
                  decoration: Style().dekorasiDropdown(),
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    value: _toko,
                    onChanged: (value) {
                      setState(() {
                        _toko = value!;
                        _idToko = _listIdToko[_listToko.indexOf(_toko)];
                      });
                      setStateB(() {});
                    },
                    items: _listToko.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    ).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    underline: const SizedBox(),
                  ),
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
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            Visibility(
              visible: isUpdate,
              child: ElevatedButton(
                onPressed: () {
                  aktivasiKaryawan(_username.text, _isActive);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                ),
                child: Text(
                  _isActive == 0 ? "Aktifkan" : "Nonaktifkan",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
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
                if (_username.text.isEmpty ||
                    !_phone.text.isPhoneNumber ||
                    _nama.text.isEmpty) {
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
                  if (!isUpdate) {
                    if (_password.text.length < 5) {
                      Get.snackbar(
                        "Maaf",
                        "Minimal Password 5 Karakter",
                        colorText: Colors.white,
                        backgroundColor: Colors.red[900],
                      );
                    } else if (_password.text != _confirmation.text) {
                      Get.snackbar(
                        "Maaf",
                        "Password dan Konfirmasi tidak sama",
                        colorText: Colors.white,
                        backgroundColor: Colors.red[900],
                      );
                    } else {
                      sendData(false);
                    }
                  } else {
                    sendData(true);
                  }
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
  }

  void getToko() {
    Api.getData(context, "toko/getToko").then((value) {
      if (value!.status == "success") {
        for (var data in value.data!) {
          _listIdToko.add(data["id"]);
          _listToko.add(data["nama"]);
        }
        setState(() {});
      }
    });
  }

  void sendData(bool isUpdate) {
    Api.postData(context, "users/insert", {
      "is_update": isUpdate,
      "username": _username.text,
      "password": _password.text,
      "nama": _nama.text,
      "phone": _phone.text,
      "id_toko": _idToko,
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
        getKaryawan();
      }
    });
  }

  void aktivasiKaryawan(String username, int isActive) {
    Api.postData(context, "users/aktivasi", {
      "username": username,
      "is_active": isActive == 0 ? 1 : 0,
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
        getKaryawan();
      }
    });
  }
}
