import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:istakip/model/proje_model.dart';
import 'package:istakip/sabitler/tema.dart';
import 'package:istakip/sayfalar/proje/projeler.dart';
import 'package:istakip/servis/veri_gonder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sabitler/ext.dart';
import '../../widget/bilgiSatir.dart';

class ProjeSayfasi extends StatefulWidget {
  final ProjeModel? proje;
  final bool ekle;
  ProjeSayfasi({this.proje, this.ekle: false});

  @override
  State<ProjeSayfasi> createState() => _ProjeSayfasiState();
}

class _ProjeSayfasiState extends State<ProjeSayfasi> {
  final formKey = GlobalKey<FormState>();
  Tema tema = Tema();
  HtmlEditorController controller = HtmlEditorController();
  bool ekle = false;
  ProjeModel? proje;
  Map<String, dynamic> bilgiler = {};

  int? projeAciliyet;
  List<List> aciliyetler = [
    [0, "Acil"],
    [1, "Normal"],
    [2, "Acelesi Yok"],
  ];

  int? projeDurum;
  List<List> durumlar = [
    [0, "Yeni Başlandı"],
    [1, "Devam Ediyor"],
    [2, "Bitti"],
  ];

  @override
  Widget build(BuildContext context) {
    ekle = widget.ekle;
    proje = widget.proje;

    if (projeDurum == null) {
      projeDurum = ekle ? 0 : proje!.projeDurum!;
    }

    if (projeAciliyet == null) {
      projeAciliyet = ekle ? 0 : proje!.projeAciliyet!;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: renk(arka_renk),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            ekle ? "proje_ekle".tr : "proje_duzenle".tr,
            style: GoogleFonts.quicksand(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  bilgiler['proje_detay'] = await controller.getText();
                  bilgiler['proje_durum'] = projeDurum;
                  bilgiler['proje_aciliyet'] = projeAciliyet;

                  var gonder = VeriGonder();

                  int id = 0;

                  if (proje != null) {
                    id = proje!.projeId!;
                  }

                  Map sonuc = await gonder.projeKaydet(bilgiler, id, ekleme: ekle);
                  if (sonuc['durum'] == "ok") {
                    alt_mesaj(context, "proje_kayit_ok".tr, tur: 1);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProjelerSayfasi()));
                  } else {
                    alt_mesaj(context, sonuc['mesaj']);
                  }
                }
              },
              icon: Icon(Icons.save),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
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
                        ekle
                            ? Container()
                            : AutoSizeText(
                                proje!.projeBaslik!,
                                style: GoogleFonts.quicksand(
                                    fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                        SizedBox(height: 10),
                        editBilgiSatir(
                          "baslik".tr,
                          TextFormField(
                            decoration: tema.editInputDec("---"),
                            initialValue: ekle ? "" : proje!.projeBaslik.toString(),
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['proje_baslik'] = val.toString();
                            },
                          ),
                        ),
                        editBilgiSatir(
                          "baslangic".tr,
                          TextFormField(
                            inputFormatters: [tarihFormat],
                            decoration: tema.editInputDec("2022-01-30"),
                            initialValue: ekle
                                ? ""
                                : proje!.projeBaslamaTarihi == null
                                    ? "---"
                                    : proje!.projeBaslamaTarihi!,
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['proje_baslama_tarihi'] = val;
                            },
                            validator: (value) {
                              String? sonuc = tarih_kontrol(value!);
                              if (sonuc != null) {
                                return sonuc;
                              }
                            },
                          ),
                        ),
                        editBilgiSatir(
                          "bitis".tr,
                          TextFormField(
                            inputFormatters: [tarihFormat],
                            decoration: tema.editInputDec("2022-01-30"),
                            initialValue: ekle
                                ? ""
                                : proje!.projeTeslimTarihi == null
                                    ? "---"
                                    : proje!.projeTeslimTarihi!,
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['proje_teslim_tarihi'] = tarih_duzelt(val.toString());
                            },
                            validator: (value) {
                              String? sonuc = tarih_kontrol(value!);
                              if (sonuc != null) {
                                return sonuc;
                              }
                            },
                          ),
                        ),
                        editBilgiSatir(
                          "aciliyet".tr,
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Text(
                                'Aciliyet Seçin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: aciliyetler
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
                              value: projeAciliyet.toString(),
                              onChanged: (value) {
                                setState(() {
                                  projeAciliyet = int.parse(value.toString());
                                  print(projeAciliyet);
                                });
                              },
                              customButton: Row(
                                children: [
                                  Text(
                                    projeAciliyet == null ? "Aciliyet Seçin" : aciliyet(projeAciliyet),
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          /* TextFormField(
                            decoration: tema.editInputDec("---"),
                            initialValue: ekle ? "" : proje!.projeAciliyet.toString(),
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['proje_aciliyet'] = val;
                            },
                          ),*/
                        ),
                        editBilgiSatir(
                          "durum".tr,
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              hint: Text(
                                'Durum Seçin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: durumlar
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
                              value: projeDurum.toString(),
                              onChanged: (value) {
                                setState(() {
                                  projeDurum = int.parse(value.toString());
                                  print(projeDurum);
                                });
                              },
                              customButton: Row(
                                children: [
                                  Text(
                                    projeDurum == null ? "Durum Seçin" : durum(projeDurum),
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          /*TextFormField(
                            decoration: tema.editInputDec("---"),
                            initialValue: ekle ? "" : proje!.projeDurum.toString(),
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['proje_durum'] = val;
                            },
                          )*/
                        ),
                        editBilgiSatir(
                          "yuzde".tr,
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: tema.editInputDec("0"),
                            initialValue: ekle ? "" : proje!.yuzde.toString(),
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['yuzde'] = val;
                            },
                            validator: (val) {
                              if (val != null) {
                                int sayi = int.parse(val.toString());
                                if (sayi > 100) {
                                  return "Yüzde 100'den büyük olamaz";
                                } else if (sayi < 0) {
                                  return "Yüzde 0'den küçük olamaz";
                                }
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              bilgiler['dosya'] = result.files.single.path!;
                            } else {
                              if (ekle || proje!.dosyaYolu == null) {
                                bilgiler['dosya'] = "";
                              }
                              print("DOSYA SEÇİLMEDİ");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "yukle".tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 900,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white54,
                          offset: Offset(0, 7),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Platform.isWindows
                        ? Column(
                            children: [
                              Text(
                                "Windows cihazda bu alanı düzenleyemezsiniz, mobil uygulama veya web sitesi üzerinden bu alanı düzenleyebilirsiniz.",
                                style: GoogleFonts.quicksand(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              Html(
                                  data: ekle ? "" : widget.proje!.projeDetay!,
                                  onLinkTap:
                                      (String? url, RenderContext context, Map<String, String> attributes, element) {
                                    launch(url!);
                                  }),
                            ],
                          )
                        : HtmlEditor(
                            htmlToolbarOptions: HtmlToolbarOptions(
                              toolbarType: ToolbarType.nativeGrid,
                            ),
                            controller: controller, //required
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: "proje_detay".tr,
                              initialText: ekle ? "" : proje!.projeDetay,
                            ),
                            otherOptions: OtherOptions(
                              height: 900,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
