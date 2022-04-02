import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ext.dart';

class Tema {
  editInputDec(String hintText) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: GoogleFonts.quicksand(
        color: Colors.grey.withOpacity(0.7),
      ),
    );
  }

  inputDec(String hintText, IconData icon) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: GoogleFonts.quicksand(
        color: renk(metin_renk),
        letterSpacing: 0,
      ),
      prefixIcon: Icon(
        icon,
        color: renk("5BA7FB"),
      ),
    );
  }

  inputBoxDec() {
    return BoxDecoration(
      color: renk("333443"),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
