import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:istakip/sabitler/ext.dart';
import 'package:istakip/sabitler/tema.dart';
import 'package:istakip/servis/oturum.dart';

import '../anasayfa.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  GetStorage box = GetStorage();
  Tema tema = Tema();
  Oturum oturum = Oturum();
  String mail = "";
  String sifre = "";

  bool sifre_gozukme = false;

  oturum_durum() {
    bool x = oturum_kontrol();
    if (x) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AnaSayfa()), (route) => false);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oturum_durum();
  }

  double genislik = 0;

  @override
  Widget build(BuildContext context) {
    genislik = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: genislik,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: renk(arka_renk),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Platform.isWindows ? genislik / 1.5 : genislik,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: renk("2D2F3A"),
                              width: 15,
                            ),
                          ),
                          child: Icon(
                            Icons.login,
                            size: 45,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "giris".tr,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Container(
                        decoration: tema.inputBoxDec(),
                        margin: EdgeInsets.only(top: 30, bottom: 10, right: 30, left: 30),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        child: TextFormField(
                          onChanged: (value) => mail = value,
                          decoration: tema.inputDec("mail_girin".tr, Icons.people_alt_outlined),
                          style: GoogleFonts.quicksand(
                            color: renk(metin_renk),
                          ),
                        ),
                      ),
                      Container(
                        decoration: tema.inputBoxDec(),
                        margin: EdgeInsets.only(top: 5, bottom: 30, right: 30, left: 30),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) => sifre = value,
                                obscureText: !sifre_gozukme,
                                decoration: tema.inputDec("sifre_girin".tr, Icons.vpn_key_outlined),
                                style: GoogleFonts.quicksand(
                                    color: renk(metin_renk), letterSpacing: !sifre_gozukme ? 10 : 0),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  sifre_gozukme = !sifre_gozukme;
                                });
                              },
                              icon: Icon(
                                sifre_gozukme ? Icons.close : Icons.remove_red_eye,
                                color: renk("7F8C99"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (mail.length < 3 || !mail.contains("@")) {
                            alt_mesaj(context, "Lütfen Doğru E-Mail Adresi Girin");
                          } else if (sifre.length < 2) {
                            alt_mesaj(context, "Şifre Uzunluğu 2 Karakterden Fazla Olmalıdır");
                          } else {
                            bool durum = await oturum.oturum_ac(context, mail, sifre);
                            if (durum) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnaSayfa(),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          //margin: EdgeInsets.symmetric(horizontal: 50),
                          width: Platform.isWindows ? genislik / 3 : genislik / 1.5,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                renk("4E73DF"),
                                renk("224ABE"),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: renk("2D2F3A"),
                                offset: Offset(0, 4),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "giris".tr,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              child: Text("EN",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  colors: [
                                    renk("4E73DF"),
                                    renk("224ABE"),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                            ),
                            onTap: () async {
                              await box.write("dil", "en");
                              Get.updateLocale(Locale("en", "US"));
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("TR",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.white,
                                  ],
                                  begin: Alignment(2, -2),
                                  end: Alignment(-7, 5),
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                            ),
                            onTap: () async {
                              await box.write("dil", "tr");
                              Get.updateLocale(Locale("tr", "TR"));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Powered by Aksoyhlc",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(color: Colors.white.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
