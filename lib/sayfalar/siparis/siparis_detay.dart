import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:istakip/model/siparis_model.dart';
import 'package:istakip/sayfalar/siparis/siparis_duzenle.dart';
import 'package:istakip/sayfalar/siparis/siparisler.dart';
import 'package:istakip/servis/veri_gonder.dart';
import 'package:istakip/widget/bilgiSatir.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sabitler/ext.dart';

class SiparisDetay extends StatefulWidget {
  final SiparisModel siparis;
  SiparisDetay(this.siparis);

  @override
  State<SiparisDetay> createState() => _SiparisDetayState();
}

class _SiparisDetayState extends State<SiparisDetay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: renk(arka_renk),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "siparis_detay".tr,
            style: GoogleFonts.quicksand(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                VeriGonder gonder = VeriGonder();
                Map sonuc = await gonder.siparisSil(widget.siparis.sipId!);

                if (sonuc['durum'] == "ok") {
                  alt_mesaj(context, "Sipariş Silme İşlemi Başarılı", tur: 1);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SiparislerSayfasi()));
                } else {
                  alt_mesaj(context, "Sipariş Silinemedi:\n" + sonuc['mesaj']);
                }
              },
              icon: Icon(Icons.delete_forever),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SiparisSayfasi(siparis: widget.siparis),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(20),
                decoration:
                    BoxDecoration(color: renk(kirmizi_renk), borderRadius: BorderRadius.circular(30), boxShadow: [
                  BoxShadow(
                    color: renk("F64250"),
                    offset: Offset(0, 7),
                    blurRadius: 10,
                  ),
                ]),
                child: Column(
                  children: [
                    AutoSizeText(
                      widget.siparis.sipBaslik!,
                      style: GoogleFonts.quicksand(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    bilgiSatir("baslangic".tr, widget.siparis.sipBaslamaTarih!),
                    bilgiSatir("bitis".tr, widget.siparis.sipTeslimTarihi!),
                    bilgiSatir("aciliyet".tr, aciliyet(widget.siparis.sipAciliyet)),
                    bilgiSatir("durum".tr, durum(widget.siparis.sipDurum)),
                    bilgiSatir("yuzde".tr, widget.siparis.yuzde.toString() + "%"),
                    bilgiSatir("ucret".tr, widget.siparis.sipUcret.toString()),
                    widget.siparis.dosyaYolu != null
                        ? InkWell(
                            onTap: () {
                              dosya_indir(context, widget.siparis.dosyaYolu!, widget.siparis.sipBaslik!);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "indir".tr,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: renk(mavi_renk), borderRadius: BorderRadius.circular(30), boxShadow: [
                  BoxShadow(
                    color: renk("36C2CF"),
                    offset: Offset(0, 7),
                    blurRadius: 10,
                  ),
                ]),
                child: Column(
                  children: [
                    AutoSizeText(
                      "musteri_bilgileri".tr,
                      //widget.proje.projeBaslik!,
                      style: GoogleFonts.quicksand(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    bilgiSatir("isim".tr, widget.siparis.musteriIsim!, baslik_arka_renk: "09B4C3"),
                    bilgiSatir("telefon:".tr, widget.siparis.musteriTelefon!.toString(), baslik_arka_renk: "09B4C3"),
                    bilgiSatir("E-Mail:", widget.siparis.musteriMail!, baslik_arka_renk: "09B4C3"),
                  ],
                ),
              ),
              widget.siparis.sipDetay == null
                  ? Container()
                  : widget.siparis.sipDetay!.length < 3
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 30, right: 15, left: 15),
                          decoration:
                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
                            BoxShadow(
                              color: Colors.white54,
                              offset: Offset(0, 7),
                              blurRadius: 10,
                            ),
                          ]),
                          child: Html(
                            data: widget.siparis.sipDetay!,
                            onLinkTap: (String? url, RenderContext context, Map<String, String> attributes,
                                dom.Element? element) {
                              print("LİNK: " + url!);
                              launch(url);
                            },
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
