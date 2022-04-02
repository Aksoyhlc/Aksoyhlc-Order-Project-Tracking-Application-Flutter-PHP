import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const String arka_renk = "3E4050";
const String metin_renk = "7F8C99";
const String kirmizi_renk = "F94654";
const String mavi_renk = "36C2CF";
const String api_key = "05a8acd63ecadfc55842804bc537f76e";
const String site_link = "https://google.com/";
const String api_link = "https://google.com/islemler/islem.php";

String aciliyet(int? id) {
  if (id == null) {
    return "---";
  } else {
    if (id == 0) {
      return "Acil";
    } else if (id == 1) {
      return "Normal";
    } else {
      return "Acelesi Yok";
    }
  }
}

String durum(int? id) {
  if (id == null) {
    return "---";
  } else {
    if (id == 0) {
      return "Yeni Başladı";
    } else if (id == 1) {
      return "Devam Ediyor";
    } else {
      return "Bitti";
    }
  }
}

String uzanti_bul(String metin) {
  return metin.split(".").last;
}

String? tarih_kontrol(String value) {
  List<String> tarihler = value.split("-");

  if (value.length < 8) {
    return "Lütfen Tarih Girin";
  }

  int yil = int.parse(tarihler[0]);
  int ay = int.parse(tarihler[1]);
  int gun = int.parse(tarihler[2]);
  print(tarihler);
  if (ay > 12) {
    return "Ay 12'den büyük olamaz";
  } else if (gun > 31) {
    return "Gün 31'den büyük olamaz";
  } else if (yil.toString().length < 4) {
    return "Lütfen doğru tarih girin";
  } else {
    if (value.length < 4) {
      return "Lütfen doğru tarih girin";
    }
  }
}

tarih_duzelt(String tarih) {
  print(tarih);
  List<String> tarihler = tarih.split("-");
  String yil = tarihler[0];
  String ay = tarihler[1];
  String gun = tarihler[2];

  if (ay.length == 1) {
    ay = "0" + ay;
  }

  if (gun.length == 1) {
    gun = "0" + gun;
  }

  return yil + "-" + ay + "-" + gun;
}

MaskTextInputFormatter tarihFormat =
    MaskTextInputFormatter(mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

class renk extends Color {
  static int _donustur(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  renk(final String renk_kodu) : super(_donustur(renk_kodu));
}

alt_mesaj(BuildContext context, String mesaj, {int tur: 0}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mesaj,
        style: GoogleFonts.quicksand(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(bottom: 30, right: 10, left: 10),
      behavior: SnackBarBehavior.floating,
      backgroundColor: tur == 0 ? Colors.red : Colors.green,
    ),
  );
}

bool oturum_kontrol() {
  GetStorage box = GetStorage();
  var sonuc = box.read("kul");

  if (sonuc == null || sonuc.toString().length < 20) {
    return false;
  } else {
    return true;
  }
}

dosya_indir(BuildContext context, String? link, String? baslik) async {
  try {
    String yol = (await getApplicationDocumentsDirectory()).path;
    String tam_isim = yol + "/" + link!;
    bool varmi = File(tam_isim).existsSync();

    if (!varmi) {
      Dio dio = Dio();
      print(tam_isim);
      Response sonuc = await dio.download(
        site_link + "dosyalar/" + link,
        tam_isim,
        onReceiveProgress: (count, total) {
          print(count.toString() + " - " + total.toString());
        },
      );
    }

    Widget? icerik;
    bool resim = false;
    if (["png", "jpg", "jpeg", "gif", "webp"].contains(uzanti_bul(link))) {
      resim = true;
      icerik = Image.file(File(tam_isim));
    } else {
      resim = false;
      icerik = Text(
        "Bu formatı önizleyemiyorsunuz",
        style: GoogleFonts.quicksand(fontSize: 22),
        textAlign: TextAlign.center,
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icerik!,
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: Platform.isWindows ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                  children: [
                    Platform.isWindows
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              if (resim) {
                                Share.shareFiles([tam_isim], text: baslik!);
                              } else {
                                launch(site_link + "dosyalar/" + link);
                              }
                            },
                            child: Text(
                              resim ? "Paylaş" : "Aç",
                              style: GoogleFonts.quicksand(),
                            ),
                          ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                      ),
                      child: Text(
                        "Kapat",
                        style: GoogleFonts.quicksand(),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  } catch (e) {
    print(e.toString());
    alt_mesaj(context, "Dosya İndirme İşlemi Başarısız");
  }
}
