import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:galon_aja/helper/constant.dart';
import 'package:galon_aja/helper/sharedpreferences.dart';
import 'package:galon_aja/login_page.dart';
import 'package:get/get.dart' as g;

class Api {
  String? status, message;
  List<dynamic>? data;

  Api({this.status, this.message, this.data});

  factory Api.result(dynamic object) {
    return Api(
      status: object['status'],
      message: object['message'],
      data: object['data'],
    );
  }

  static Future<Api?> getData(BuildContext context, String url) async {
    EasyLoading.show(
      status: 'Mohon Tunggu',
      dismissOnTap: false,
    );

    BaseOptions options = BaseOptions(
      baseUrl: "$apiUrl/$url",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json;charset=utf-8",
    );

    Dio dio = Dio(options);

    Api? returnData;

    try {
      Response response = await dio.get("$apiUrl$url");

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        returnData = Api.result(listData);
      } else {
        dynamic listData = {
          "status": "failed",
          "message": "Koneksi Bermasalah",
          "data": null
        };

        returnData = Api.result(listData);
      }
    } catch (e) {
      dynamic listData = {
        "status": "failed",
        "message": "Terdapat Masalah Saat Melakukan Koneksi ke Server",
        "data": null
      };

      returnData = Api.result(listData);
    }

    if (returnData.status != "success") {
      g.Get.snackbar(
        returnData.status!,
        returnData.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red[900],
      );
    }

    if (returnData.status == "logout") {
      Prefs().clearData();
      g.Get.offAll(() => const LoginPage());
    }
    EasyLoading.dismiss();
    return returnData;
  }

  static Future<Api?> postData(
      BuildContext context, String url, var data) async {
    EasyLoading.show(
      status: 'Mohon Tunggu',
      dismissOnTap: false,
    );

    BaseOptions options = BaseOptions(
        baseUrl: "$apiUrl$url",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: "application/json;charset=utf-8");

    Dio dio = Dio(options);

    Api? returnData;

    try {
      Response response = await dio.post("$apiUrl$url", data: data);

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        returnData = Api.result(listData);
      } else {
        dynamic listData = {
          "status": "failed",
          "message": "Koneksi Bermasalah",
          "data": null
        };

        returnData = Api.result(listData);
      }
    } catch (e) {
      print(e);
      dynamic listData = {
        "status": "failed",
        "message": "Terdapat Masalah Saat Melakukan Koneksi ke Server",
        "data": null
      };

      returnData = Api.result(listData);
    }

    if (returnData.status != "success") {
      g.Get.snackbar(
        returnData.status!,
        returnData.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red[900],
      );
    }

    if (returnData.status == "logout") {
      Prefs().clearData();
      g.Get.offAll(() => const LoginPage());
    }
    EasyLoading.dismiss();
    return returnData;
  }

  static Future<Api?> postDataMultiPart(
      BuildContext context, String url, FormData formData) async {
    EasyLoading.show(
      status: 'Mohon Tunggu',
      dismissOnTap: false,
    );

    BaseOptions options = BaseOptions(
      baseUrl: "$apiUrl/$url",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json;charset=utf-8",
    );

    Dio dio = Dio(options);

    Api? returnData;

    try {
      Response response = await dio.post(
        "$apiUrl$url",
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        returnData = Api.result(listData);
      } else {
        dynamic listData = {
          "status": "failed",
          "message": "Koneksi Bermasalah",
          "data": null
        };

        returnData = Api.result(listData);
      }
    } catch (e) {
      dynamic listData = {
        "status": "failed",
        "message": "Terdapat Masalah Saat Melakukan Koneksi ke Server",
        "data": null
      };

      returnData = Api.result(listData);
    }

    if (returnData.status != "success") {
      g.Get.snackbar(
        returnData.status!,
        returnData.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red[900],
      );
    }

    if (returnData.status == "logout") {
      Prefs().clearData();
      g.Get.offAll(() => const LoginPage());
    }
    EasyLoading.dismiss();
    return returnData;
  }
}
