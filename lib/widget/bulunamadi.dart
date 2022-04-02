import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../sabitler/ext.dart';

Widget bulunamadi(String metin, {bool arka: false}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: renk(arka ? kirmizi_renk : arka_renk), width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.only(top: 20,bottom: 20),
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning,
          color: renk(kirmizi_renk),
        ),
        SizedBox(width: 10),
        AutoSizeText(
          metin,
          maxLines: 1,
          style: GoogleFonts.quicksand(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: renk(arka ? kirmizi_renk : arka_renk),
          ),
        ),
        SizedBox(width: 10),
        Icon(
          Icons.warning,
          color: renk(kirmizi_renk),
        ),
      ],
    ),
  );
}
