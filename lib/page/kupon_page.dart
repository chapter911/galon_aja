import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galon_aja/helper/api.dart';
import 'package:galon_aja/helper/constant.dart';
import 'package:galon_aja/helper/format_changer.dart';
import 'package:galon_aja/helper/sharedpreferences.dart';
import 'package:galon_aja/page/home_page.dart';
import 'package:galon_aja/style/style.dart';
import 'package:get/get.dart';

class KuponPage extends StatefulWidget {
  const KuponPage({super.key});

  @override
  State<KuponPage> createState() => _KuponPageState();
}

class _KuponPageState extends State<KuponPage> {
  final TextEditingController _searchAwal = TextEditingController();
  final TextEditingController _searchAkhir = TextEditingController();
  final TextEditingController _updateAwal = TextEditingController();
  final TextEditingController _updateAkhir = TextEditingController();
  final TextEditingController _nomorKupon = TextEditingController();
  final TextEditingController _expiredDate = TextEditingController();
  final TextEditingController _namaAgenUpdate = TextEditingController();
  final TextEditingController _phoneAgenUpdate = TextEditingController();

  int _idAgen = 0;

  String _namaAgen = "",
      _phoneAgen = "",
      _isUsed = "",
      _active = "",
      _expired = "",
      _totalCoupon = "",
      _jumlahKupon = "- Pilih Jumlah -",
      _toko = "- Pilih Toko -";

  int _idToko = 0;

  final List<String> _listKupon = ["- Pilih Jumlah -", "50 Kupon", "100 Kupon"];
  final List<String> _listToko = ["- Pilih Toko -"];
  final List<int> _listIdToko = [0];
  bool _isAgree = false, _isAdmin = false, _isRange = false, _isActive = false;

  final List<Widget> _listKuponAgen = [];

  @override
  void initState() {
    super.initState();
    _isAdmin = Prefs.readInt("is_admin") == 1 ? true : false;
    _idAgen = Get.arguments['id'];
    _namaAgen = Get.arguments['nama'];
    _phoneAgen = Get.arguments['phone'];
    _isActive = Get.arguments['is_active'] == 1 ? true : false;
    _isUsed = Get.arguments['is_used'];
    _active = Get.arguments['active'];
    _expired = Get.arguments['expired'];
    _totalCoupon = Get.arguments['total_coupon'].toString();
    _namaAgenUpdate.text = Get.arguments['nama'];
    _phoneAgenUpdate.text = Get.arguments['phone'];
    setState(() {});
    getCoupon();
    getToko();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Kupon Agen"),
        actions: [
          IconButton(
            onPressed: () {
              showDialogPencarian();
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(5),
                    color: warnaPrimary,
                    child: Center(
                      child: Text(
                        _namaAgen.toUpperCase(),
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
                            const Text("Phone"),
                            const Text(":"),
                            Text(_phoneAgen, textAlign: TextAlign.end),
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
                              _isUsed,
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
                              _active,
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
                              _expired,
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
                              _totalCoupon,
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
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dialogAgen();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: warnaPrimary),
                    child: const Text(
                      "UPDATE AGEN",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      multiUpdate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text("MULTI KUPON UPDATE"),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _listKuponAgen,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAgree = false;
            _jumlahKupon = "- Pilih Jumlah -";
            _nomorKupon.text = "";
            _expiredDate.text = "";
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
                      "Input Kupon",
                      style: TextStyle(
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
                        controller: _namaAgenUpdate,
                        readOnly: true,
                        decoration: Style().dekorasiInput("Nama Agen"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _nomorKupon,
                        decoration: Style().dekorasiInput("Nomor Awal Kupon :"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _expiredDate,
                        readOnly: true,
                        decoration: Style().dekorasiInput("Tanggal Expired :"),
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2999))
                              .then((value) {
                            if (value != null) {
                              _expiredDate.text =
                                  FormatChanger().tanggalIndo(value);
                              setState(() {});
                              setStateB(() {});
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Tempat Pembelian : "),
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Jumlah Kupon : "),
                      Container(
                        decoration: Style().dekorasiDropdown(),
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          style: const TextStyle(fontWeight: FontWeight.normal),
                          borderRadius: BorderRadius.circular(10),
                          isExpanded: true,
                          value: _jumlahKupon,
                          onChanged: (value) {
                            setState(() {
                              _jumlahKupon = value!;
                            });
                            setStateB(() {});
                          },
                          items: _listKupon.map<DropdownMenuItem<String>>(
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
                      if (_nomorKupon.text.isEmpty ||
                          _expiredDate.text.isEmpty) {
                        Get.snackbar(
                          "Maaf",
                          "Anda belum mengisi seluruh data",
                          colorText: Colors.white,
                          backgroundColor: Colors.red[900],
                        );
                      } else if (_jumlahKupon == "- Pilih Jumlah -") {
                        Get.snackbar(
                          "Maaf",
                          "Anda belum menentukan jumlah kupon",
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
                        Api.postData(context, "kupon/insert", {
                          "id_agen": _idAgen,
                          "id_toko": _idToko,
                          "awal_kupon": _nomorKupon.text,
                          "expired_date": FormatChanger()
                              .tanggalAPIString(_expiredDate.text),
                          "jumlah_kupon": _jumlahKupon.replaceAll(" Kupon", ""),
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
                            _nomorKupon.text = "";
                            setState(() {});
                            getCoupon();
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
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void updateKupon(int coupon, int isUsed) {
    Api.postData(context, "kupon/update", {
      "coupon": coupon,
      "is_used": isUsed,
      "updated_by": Prefs.readString("username")
    }).then((value) {
      Get.back();
      if (value!.status == "success") {
        Get.snackbar(
          "Informasi",
          value.message!,
          backgroundColor: Colors.amber[700],
        );
        getCoupon();
      }
    });
  }

  void showDialogPencarian() {
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
                "Input Kupon",
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
                controller: _searchAwal,
                decoration: Style().dekorasiInput("Nomor Kupon :"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _searchAkhir,
                readOnly: !_isRange,
                decoration: Style().dekorasiInput("Hingga :"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                title: const Text("Gunakan Range"),
                controlAffinity: ListTileControlAffinity.leading,
                value: _isRange,
                onChanged: (val) {
                  _isRange = !_isRange;
                  if (!_isRange) {
                    _searchAkhir.text = "";
                  }
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
                setState(() {
                  _searchAwal.text = "";
                  _searchAkhir.text = "";
                });
                getCoupon();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
              ),
              child: const Text(
                "R E S E T",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_searchAwal.text.isEmpty) {
                  Get.snackbar(
                    "Maaf",
                    "Nomor Kupon Tidak Boleh Kosong",
                    colorText: Colors.white,
                    backgroundColor: Colors.red[900],
                  );
                } else if (_isRange && _searchAkhir.text.isEmpty) {
                  Get.snackbar(
                    "Maaf",
                    "Anda belum menginputkan hingga kupon berapa",
                    colorText: Colors.white,
                    backgroundColor: Colors.red[900],
                  );
                } else {
                  Get.back();
                  getCoupon();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: warnaPrimary,
              ),
              child: const Text(
                "C A R I",
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

  void getCoupon() {
    Api.postData(context, "kupon/getKupon", {
      "id_agen": _idAgen,
      "awal": _searchAwal.text.isEmpty ? "*" : _searchAwal.text,
      "akhir": _searchAkhir.text.isEmpty ? "*" : _searchAkhir.text
    }).then((value) {
      if (value!.status == "success") {
        _listKuponAgen.clear();
        for (var i = 0; i < value.data!.length; i++) {
          _listKuponAgen.add(InkWell(
            onTap: () {
              if (value.data![i]['is_used'] == 0) {
                if (Get.isSnackbarOpen) {
                  Get.closeAllSnackbars();
                } else if (value.data![i]['is_expired'] == 1) {
                  Get.snackbar(
                    "Maaf",
                    "Kupon sudah expired",
                    backgroundColor: Colors.red[900],
                    colorText: Colors.white,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      clipBehavior: Clip.antiAlias,
                      titlePadding: EdgeInsets.zero,
                      title: Container(
                        padding: const EdgeInsets.all(10),
                        color: warnaPrimary,
                        child: const Center(
                          child: Text(
                            "Gunakan Kupon ?",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      content: const Text(
                        "Kupon ini akan di ubah statusnya menjadi sudah digunakan",
                      ),
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
                            updateKupon(value.data![i]['coupon'], 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: warnaPrimary,
                          ),
                          child: const Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                if (_isAdmin) {
                  if (Get.isSnackbarOpen) {
                    Get.closeAllSnackbars();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        clipBehavior: Clip.antiAlias,
                        titlePadding: EdgeInsets.zero,
                        title: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.amber[700],
                          child: const Center(
                            child: Text("Batal Kupon ?"),
                          ),
                        ),
                        content: const Text(
                          "Kupon ini akan di ubah statusnya menjadi belum digunakan",
                        ),
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
                              updateKupon(value.data![i]['coupon'], 0);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: warnaPrimary,
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  Get.snackbar(
                    "Informasi",
                    "Kupon ini sudah digunakan sebelumnya",
                    backgroundColor: warnaPrimary,
                    colorText: Colors.white,
                  );
                }
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
                    color: value.data![i]['is_used'] == 1
                        ? Colors.green[600]
                        : value.data![i]['is_expired'] == 1
                            ? Colors.black
                            : Colors.red[600],
                    padding: const EdgeInsets.all(10),
                    child: Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.white,
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
                              "No Kupon",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              ":",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${value.data![i]['coupon']}",
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Expired",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              ":",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              FormatChanger().tanggalIndoFromString(
                                value.data![i]['expired_date'],
                              ),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Use Date",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              ":",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              FormatChanger().tanggalIndoFromString(
                                value.data![i]['used_date'],
                              ),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Update By",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              ":",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              value.data![i]['updated_by'] == null
                                  ? "-"
                                  : value.data![i]['updated_by'].toUpperCase(),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
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

  void dialogAgen() {
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
                "Update Agen",
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
                controller: _namaAgenUpdate,
                decoration: Style().dekorasiInput("Nama Agen"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _phoneAgenUpdate,
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
                Api.postData(context, "agen/aktivasi", {
                  "id": _idAgen,
                  "is_active": _isActive ? 0 : 1,
                  "updated_by": Prefs.readString("username")
                }).then((value) {
                  if (value!.status == "success") {
                    Get.offAll(() => const HomePage());
                    Get.snackbar(
                      "Informasi",
                      value.message!,
                      colorText: Colors.white,
                      backgroundColor: warnaPrimary,
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isActive ? Colors.red[900] : Colors.amber,
              ),
              child: Text(
                _isActive ? "Non-Aktifkan" : "Aktifkan",
                style: TextStyle(
                  color: _isActive ? Colors.white : Colors.black,
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
                backgroundColor: Colors.grey[900],
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
                if (_namaAgenUpdate.text.isEmpty ||
                    !_phoneAgenUpdate.text.isPhoneNumber) {
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
                  Api.postData(context, "agen/update", {
                    "id": _idAgen,
                    "nama": _namaAgenUpdate.text,
                    "phone": _phoneAgenUpdate.text,
                    "updated_by": Prefs.readString("username")
                  }).then((value) {
                    if (value!.status == "success") {
                      Get.offAll(() => const HomePage());
                      Get.snackbar(
                        "Informasi",
                        value.message!,
                        colorText: Colors.white,
                        backgroundColor: warnaPrimary,
                      );
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
  }

  void multiUpdate() {
    setState(() {
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
                "Multi Update Kupon",
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
                controller: _updateAwal,
                decoration: Style().dekorasiInput("Nomor Awal Kupon :"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _updateAkhir,
                decoration: Style().dekorasiInput("Nomor Akhir Kupon :"),
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
                if (_updateAwal.text.isEmpty || _updateAkhir.text.isEmpty) {
                  Get.snackbar(
                    "Maaf",
                    "Anda belum mengisi seluruh data",
                    colorText: Colors.white,
                    backgroundColor: Colors.red[900],
                  );
                } else if (int.parse(_updateAwal.text) >
                    int.parse(_updateAkhir.text)) {
                  Get.snackbar(
                    "Maaf",
                    "Nomor awal harus lebih kecil dari nomor akhir",
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
                  Api.postData(context, "kupon/multiUpdate", {
                    "id_agen": _idAgen,
                    "awal_kupon": _updateAwal.text,
                    "akhir_kupon": _updateAkhir.text,
                    "updated_by": Prefs.readString("username")
                  }).then((value) {
                    Get.back();
                    if (value!.status == "success") {
                      Get.snackbar(
                        "Informasi",
                        value.message!,
                        colorText: Colors.white,
                        backgroundColor: warnaPrimary,
                      );
                      _updateAwal.text = "";
                      _updateAkhir.text = "";
                      setState(() {});
                      getCoupon();
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
}
