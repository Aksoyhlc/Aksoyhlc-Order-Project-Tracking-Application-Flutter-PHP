import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:istakip/model/proje_model.dart';
import 'package:istakip/sayfalar/proje/proje_sayfasi.dart';
import 'package:istakip/sayfalar/proje/projeler.dart';
import 'package:istakip/servis/veri_gonder.dart';
import 'package:istakip/widget/bilgiSatir.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sabitler/ext.dart';

class ProjeDetay extends StatefulWidget {
  final ProjeModel proje;
  ProjeDetay(this.proje);

  @override
  State<ProjeDetay> createState() => _ProjeDetayState();
}

class _ProjeDetayState extends State<ProjeDetay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: renk(arka_renk),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "proje_detay".tr,
            style: GoogleFonts.quicksand(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                VeriGonder gonder = VeriGonder();
                Map sonuc = await gonder.projeSil(widget.proje.projeId!);

                if (sonuc['durum'] == "ok") {
                  alt_mesaj(context, "Proje Silme İşlemi Başarılı", tur: 1);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProjelerSayfasi()));
                } else {
                  alt_mesaj(context, "Proje Silinemedi:\n" + sonuc['mesaj']);
                }
              },
              icon: Icon(Icons.delete_forever),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProjeSayfasi(proje: widget.proje)));
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
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
                        widget.proje.projeBaslik!,
                        style: GoogleFonts.quicksand(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      bilgiSatir("baslangic".tr,
                          widget.proje.projeBaslamaTarihi == null ? "---" : widget.proje.projeBaslamaTarihi!),
                      bilgiSatir(
                          "bitis".tr, widget.proje.projeTeslimTarihi == null ? "---" : widget.proje.projeTeslimTarihi!),
                      bilgiSatir("aciliyet".tr, aciliyet(widget.proje.projeAciliyet)),
                      bilgiSatir("durum".tr, durum(widget.proje.projeDurum)),
                      bilgiSatir("yuzde".tr, widget.proje.yuzde.toString() + "%"),
                      widget.proje.dosyaYolu != null
                          ? InkWell(
                              onTap: () async {
                                dosya_indir(context, widget.proje.dosyaYolu!, widget.proje.projeBaslik!);
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
                widget.proje.projeDetay == null
                    ? Container()
                    : widget.proje.projeDetay!.length < 3
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 30),
                            decoration:
                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
                              BoxShadow(
                                color: Colors.white54,
                                offset: Offset(0, 7),
                                blurRadius: 10,
                              ),
                            ]),
                            child: Html(
                                data: widget.proje.projeDetay!,
                                onLinkTap: (String? url, RenderContext context, Map<String, String> attributes,
                                    dom.Element? element) {
                                  print("LİNK: " + url!);
                                  launch(url);
                                }),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
