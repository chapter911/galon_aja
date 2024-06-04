import 'package:flutter/material.dart';
import 'package:galon_aja/helper/constant.dart';

class Style {
  InputDecoration dekorasiInput(hint, {icon}) {
    return InputDecoration(
      hintText: hint ?? "",
      label: Text(hint),
      prefixIcon: icon,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
    );
  }

  BoxDecoration dekorasiDropdown({Color? warnaFill}) {
    return BoxDecoration(
      color: warnaFill ?? Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black),
    );
  }

  BoxDecoration dekorasiIconButton({warna}) {
    return BoxDecoration(
      color: warna ?? warnaPrimary,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }
}
