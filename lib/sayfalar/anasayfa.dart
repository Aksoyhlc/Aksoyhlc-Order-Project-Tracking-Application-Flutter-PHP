import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:istakip/controller/genelController.dart';
import 'package:istakip/model/proje_model.dart';
import 'package:istakip/sabitler/ext.dart';
import 'package:istakip/sayfalar/oturum/giris.dart';
import 'package:istakip/sayfalar/proje/projeler.dart';
import 'package:istakip/sayfalar/siparis/siparis_detay.dart';
import 'package:istakip/sayfalar/siparis/siparisler.dart';
import 'package:istakip/servis/veri_getir.dart';
import 'package:istakip/widget/bottomBar.dart';
import 'package:istakip/widget/bulunamadi.dart';
import 'package:istakip/widget/projeBox.dart';
import 'package:istakip/widget/siparisBox.dart';

import '../dil.dart';
import '../model/siparis_model.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  GenelController genelController = Get.put(GenelController());
  GetStorage box = GetStorage();
  List<List> diller = [
    ["tr", "Türkçe"],
    ["en", "English"],
  ];

  VeriGetir veriGetir = VeriGetir();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await box.remove("kul");
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => GirisSayfasi()), (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Text(
                    "dil_secin".tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: diller
                      .map((item) => DropdownMenuItem<String>(
                            value: item.first.toString(),
                            child: Text(
                              item.last,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: box.read("dil") == null ? "tr" : box.read("dil"),
                  onChanged: (value) {
                    if (value == "tr") {
                      box.write("dil", "tr");
                      Get.updateLocale(Dil.tr);
                    } else {
                      box.write("dil", "en");
                      Get.updateLocale(Dil.en);
                    }
                    alt_mesaj(context, "dil_degisti".tr, tur: 1);
                  },
                  customButton: Row(
                    children: [
                      Text(
                        "dil_secin".tr,
                        style: GoogleFonts.quicksand(color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 15),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.keyboard_arrow_down_sharp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomBar(context),
        backgroundColor: renk(arka_renk),
        body: Column(
          children: [
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: veriGetir.siparisleri_getir(limit: "2"),
                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List? sonuc = snapshot.data;
                    if (sonuc!.first) {
                      List siparisler = sonuc.last;
                      if (siparisler.length == 0) {
                        return bulunamadi("SİPARİŞ BULUNAMADI");
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: siparisler.length,
                          itemBuilder: (context, index) {
                            SiparisModel siparis = siparisler[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SiparisDetay(siparis)));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(
                                  color: renk("F94654"),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          siparis.sipTeslimTarihi!,
                                          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          siparis.sipBaslik!,
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: renk("E22231"),
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          siparis.yuzde.toString() + " %",
                                          style: GoogleFonts.bebasNeue(
                                              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      width: 60,
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return bulunamadi("BİR HATAYLA KARŞILAŞILDI");
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 25, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Son Projeler",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjelerSayfasi(),
                                ),
                              );
                            },
                            child: Text(
                              "Tüm Projeler",
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: renk("F94654"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: veriGetir.projeleri_getir(),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            List? sonuc = snapshot.data;
                            if (sonuc!.first) {
                              List projeler = sonuc.last;
                              if (projeler.length == 0) {
                                return bulunamadi("PROJE BULUNAMADI");
                              } else {
                                List<Widget> ogeler = [];

                                for (var i = 0; i <= projeler.length - 1; i++) {
                                  ProjeModel proje = projeler[i];
                                  ogeler.add(projeBox(context, proje));
                                }
                                return Column(
                                  children: ogeler,
                                );
                              }
                            } else {
                              return bulunamadi("BİR HATAYLA KARŞILAŞILDI");
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Son Siparişler",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SiparislerSayfasi(),
                                ),
                              );
                            },
                            child: Text(
                              "Tüm Siparişler",
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: renk("F94654"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: veriGetir.siparisleri_getir(limit: "2,3"),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (snapshot.hasData) {
                            List? sonuc = snapshot.data;
                            if (sonuc!.first) {
                              List siparisler = sonuc.last;
                              if (siparisler.length == 0) {
                                return bulunamadi("SİPARİŞ BULUNAMADI");
                              } else {
                                List<Widget> ogeler = [];

                                for (var i = 0; i <= siparisler.length - 1; i++) {
                                  SiparisModel siparis = siparisler[i];
                                  ogeler.add(siparisBox(context, siparis));
                                }
                                return Column(
                                  children: ogeler,
                                );
                              }
                            } else {
                              return bulunamadi("BİR HATAYLA KARŞILAŞILDI");
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
