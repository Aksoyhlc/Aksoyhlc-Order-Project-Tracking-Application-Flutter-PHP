import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:istakip/model/proje_model.dart';

import '../sabitler/ext.dart';
import '../sayfalar/proje/proje_detay.dart';

Widget projeBox(BuildContext context, ProjeModel proje) {
  bool bittimi = proje.yuzde == 100 ? true : false;
  Color metin_renk = bittimi ? Colors.white : renk(arka_renk);
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjeDetay(proje)));
    },
    child: Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(right: 15, left: 15, top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: renk(arka_renk), width: 1),
          borderRadius: BorderRadius.circular(15),
          color: bittimi ? Colors.green : Colors.transparent),
      child: Row(
        children: [
          Container(
            child: Center(
              child: Text(
                proje.yuzde.toString(),
                style: GoogleFonts.bebasNeue(color: bittimi ? renk(arka_renk) : Colors.white, fontSize: 30),
              ),
            ),
            decoration: BoxDecoration(
              color: metin_renk,
              borderRadius: BorderRadius.circular(100),
            ),
            width: 50,
            height: 50,
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proje.projeBaslik!,
                style: GoogleFonts.quicksand(fontWeight: FontWeight.w900, fontSize: 20, color: metin_renk),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(aciliyet(proje.projeAciliyet), style: GoogleFonts.quicksand(color: metin_renk)),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: bittimi ? Colors.white : renk(arka_renk), borderRadius: BorderRadius.circular(100)),
                  ),
                  Text(
                    proje.projeTeslimTarihi == null ? "" : proje.projeTeslimTarihi!,
                    style: GoogleFonts.quicksand(color: metin_renk),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.chevron_right,
                  color: metin_renk,
                  size: 40,
                ),
              ),
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    ),
  );
}
