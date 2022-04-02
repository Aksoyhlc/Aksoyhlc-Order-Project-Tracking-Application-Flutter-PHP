import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:istakip/model/proje_model.dart';
import 'package:istakip/sabitler/ext.dart';
import 'package:istakip/sayfalar/proje/proje_detay.dart';
import 'package:istakip/servis/veri_getir.dart';
import 'package:istakip/widget/projeBox.dart';

import '../../controller/genelController.dart';
import '../../widget/bottomBar.dart';
import '../../widget/bulunamadi.dart';
import '../anasayfa.dart';

class ProjelerSayfasi extends StatefulWidget {
  const ProjelerSayfasi({Key? key}) : super(key: key);

  @override
  State<ProjelerSayfasi> createState() => _ProjelerSayfasiState();
}

class _ProjelerSayfasiState extends State<ProjelerSayfasi> {
  GenelController controller = Get.find<GenelController>();
  VeriGetir veriGetir = VeriGetir();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          controller.secilen_menu.value = 2;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AnaSayfa()), (route) => false);
          return Future.value(false);
        },
        child: Scaffold(
          bottomNavigationBar: bottomBar(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "tum_projeler".tr,
              style: GoogleFonts.quicksand(),
            ),
          ),
          backgroundColor: renk(arka_renk),
          body: Column(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: veriGetir.projeleri_getir(limit: "1"),
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      List? sonuc = snapshot.data;
                      if (sonuc!.first) {
                        List projeler = sonuc.last;
                        if (projeler.length == 0) {
                          return bulunamadi("PROJE BULUNAMADI", arka: true);
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: projeler.length,
                            itemBuilder: (context, index) {
                              ProjeModel proje = projeler[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProjeDetay(proje)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  decoration: BoxDecoration(
                                    color: renk("F94654"),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            proje.projeTeslimTarihi!,
                                            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            proje.projeBaslik!,
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
                                            proje.yuzde.toString() + " %",
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
                      return Center(child: CircularProgressIndicator());
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
                    child: FutureBuilder(
                      future: veriGetir.projeleri_getir(limit: "1,99999999"),
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
