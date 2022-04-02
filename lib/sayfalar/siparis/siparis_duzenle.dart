import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:istakip/model/siparis_model.dart';
import 'package:istakip/sabitler/tema.dart';
import 'package:istakip/sayfalar/siparis/siparisler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sabitler/ext.dart';
import '../../servis/veri_gonder.dart';
import '../../widget/bilgiSatir.dart';

class SiparisSayfasi extends StatefulWidget {
  SiparisModel? siparis;
  bool ekleme;
  SiparisSayfasi({this.siparis, this.ekleme: false});

  @override
  State<SiparisSayfasi> createState() => _SiparisSayfasiState();
}

class _SiparisSayfasiState extends State<SiparisSayfasi> {
  final formKey = GlobalKey<FormState>();
  Tema tema = Tema();
  HtmlEditorController controller = HtmlEditorController();

  bool ekleme = false;
  SiparisModel? siparis;

  Map<String, dynamic> bilgiler = {};

  int? sipAciliyet;
  List<List> aciliyetler = [
    [0, "Acil"],
    [1, "Normal"],
    [2, "Acelesi Yok"],
  ];

  int? sipDurum;
  List<List> durumlar = [
    [0, "Yeni Başlandı"],
    [1, "Devam Ediyor"],
    [2, "Bitti"],
  ];

  @override
  Widget build(BuildContext context) {
    ekleme = widget.ekleme;
    siparis = widget.siparis;
    if (sipDurum == null) {
      sipDurum = ekleme ? 0 : siparis!.sipDurum!;
    }

    if (sipAciliyet == null) {
      sipAciliyet = ekleme ? 0 : siparis!.sipAciliyet!;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: renk(arka_renk),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            ekleme ? "siparis_ekle".tr : "siparis_duzenle".tr,
            style: GoogleFonts.quicksand(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  bilgiler['sip_detay'] = await controller.getText();
                  bilgiler['sip_durum'] = sipDurum;
                  bilgiler['sip_aciliyet'] = sipAciliyet;
                  var gonder = VeriGonder();
                  int id = 0;

                  if (!ekleme) {
                    id = siparis!.sipId!;
                  }

                  Map sonuc = await gonder.siparisKaydet(bilgiler, id, ekleme: ekleme);
                  if (sonuc['durum'] == "ok") {
                    alt_mesaj(context, "sip_kayit_ok".tr, tur: 1);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SiparislerSayfasi(),
                        ));
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
          child: SingleChildScrollView(
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
                      ekleme
                          ? Container()
                          : AutoSizeText(
                              siparis!.sipBaslik!,
                              style:
                                  GoogleFonts.quicksand(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                      SizedBox(height: 10),
                      editBilgiSatir(
                        "baslik".tr,
                        TextFormField(
                          decoration: tema.editInputDec("---"),
                          initialValue: ekleme ? "" : siparis!.sipBaslik.toString(),
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['sip_baslik'] = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "baslik_bos".tr;
                            }
                          },
                        ),
                      ),
                      editBilgiSatir(
                        "baslangic".tr,
                        TextFormField(
                          inputFormatters: [tarihFormat],
                          decoration: tema.editInputDec("2022-01-30"),
                          initialValue: ekleme
                              ? ""
                              : siparis!.sipBaslamaTarih == null
                                  ? "---"
                                  : siparis!.sipBaslamaTarih!,
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['sip_baslama_tarih'] = val;
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
                          initialValue: ekleme
                              ? ""
                              : siparis!.sipTeslimTarihi == null
                                  ? "---"
                                  : siparis!.sipTeslimTarihi!,
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['sip_teslim_tarihi'] = val;
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
                            value: sipAciliyet.toString(),
                            onChanged: (value) {
                              setState(() {
                                sipAciliyet = int.parse(value.toString());
                                print(sipAciliyet);
                              });
                            },
                            customButton: Row(
                              children: [
                                Text(
                                  sipAciliyet == null ? "Aciliyet Seçin" : aciliyet(sipAciliyet),
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
                          initialValue: ekleme ? "" : siparis!.sipAciliyet.toString(),
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['sip_aciliyet'] = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Aciliyet Alanı Boş Olamaz";
                            }
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
                            value: sipDurum.toString(),
                            onChanged: (value) {
                              setState(() {
                                sipDurum = int.parse(value.toString());
                                print(sipDurum);
                              });
                            },
                            customButton: Row(
                              children: [
                                Text(
                                  sipDurum == null ? "Durum Seçin" : durum(sipDurum),
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
                          initialValue: ekleme ? "" : siparis!.sipDurum.toString(),
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['sip_durum'] = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Durum Alanı Boş Olamaz";
                            }
                          },
                        ),*/
                      ),
                      editBilgiSatir(
                        "yuzde".tr,
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: tema.editInputDec("0"),
                          initialValue: ekleme ? "0" : siparis!.yuzde.toString(),
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
                      editBilgiSatir(
                        "ucret".tr,
                        TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: tema.editInputDec("0"),
                            initialValue: ekleme ? "0" : siparis!.sipUcret.toString(),
                            style: GoogleFonts.quicksand(),
                            onSaved: (val) {
                              bilgiler['sip_ucret'] = val;
                            }),
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();

                          if (result != null) {
                            bilgiler['dosya'] = result.files.single.path!;
                          } else {
                            if (ekleme || siparis!.dosyaYolu == null) {
                              bilgiler['dosya'] = "";
                            }
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
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(color: renk(mavi_renk), borderRadius: BorderRadius.circular(30), boxShadow: [
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
                        style: GoogleFonts.quicksand(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      editBilgiSatir(
                        "isim".tr,
                        TextFormField(
                          decoration: tema.editInputDec("---"),
                          initialValue: ekleme ? "" : HtmlUnescape().convert(siparis!.musteriIsim.toString()),
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['musteri_isim'] = val;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Müşteri ismi boş olamaz";
                            }
                          },
                        ),
                        baslik_arka_renk: "09B4C3",
                      ),
                      editBilgiSatir(
                        "telefon".tr,
                        TextFormField(
                          decoration: tema.editInputDec("---"),
                          keyboardType: TextInputType.phone,
                          initialValue: ekleme ? "" : siparis!.musteriTelefon.toString(),
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['musteri_telefon'] = val;
                          },
                        ),
                        baslik_arka_renk: "09B4C3",
                      ),
                      editBilgiSatir(
                        "E-Mail:",
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: tema.editInputDec("---"),
                          initialValue: ekleme ? "" : siparis!.musteriMail.toString(),
                          style: GoogleFonts.quicksand(),
                          onSaved: (val) {
                            bilgiler['musteri_mail'] = val;
                          },
                        ),
                        baslik_arka_renk: "09B4C3",
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 30, right: 15, left: 15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
                    BoxShadow(
                      color: Colors.white54,
                      offset: Offset(0, 7),
                      blurRadius: 10,
                    ),
                  ]),
                  child: Platform.isWindows
                      ? Column(
                          children: [
                            Text(
                              "Windows cihazda bu alanı düzenleyemezsiniz, mobil uygulama veya web sitesi üzerinden bu alanı düzenleyebilirsiniz.",
                              style: GoogleFonts.quicksand(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Html(
                                data: ekleme ? "" : widget.siparis!.sipDetay!,
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
                            hint: "siparis_detay".tr,
                            initialText: ekleme ? "" : siparis!.sipDetay,
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
    );
  }
}
