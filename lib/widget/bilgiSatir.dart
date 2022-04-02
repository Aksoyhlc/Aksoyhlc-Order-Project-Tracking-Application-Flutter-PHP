import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';

import '../sabitler/ext.dart';

Widget bilgiSatir(String baslik, String icerik, {String baslik_arka_renk: "CA0E1D", String on_renk: "FFFFFF"}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Container(
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            color: renk(baslik_arka_renk),
          ),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 8),
          child: AutoSizeText(
            baslik,
            style: GoogleFonts.quicksand(
              color: renk(on_renk),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 8),
            child: AutoSizeText(
              HtmlUnescape().convert(icerik),
              style: GoogleFonts.quicksand(
                color: renk(arka_renk),
                fontSize: 15,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget editBilgiSatir(String baslik, Widget icerik, {String baslik_arka_renk: "CA0E1D", String on_renk: "FFFFFF"}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Container(
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            color: renk(baslik_arka_renk),
          ),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 8),
          child: AutoSizeText(
            baslik,
            style: GoogleFonts.quicksand(
              color: renk(on_renk),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 8),
            child: icerik,
          ),
        ),
      ],
    ),
  );
}
