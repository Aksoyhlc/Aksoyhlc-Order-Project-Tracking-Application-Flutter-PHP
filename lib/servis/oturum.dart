import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:istakip/model/kullanici.dart';
import 'package:istakip/sabitler/ext.dart';

class Oturum {
  GetStorage box = GetStorage();
  Future<bool> oturum_ac(BuildContext context, String mail, String sifre) async {
    print(api_link + "?api_key=" + api_key);
    http.Response sonuc = await http.post(Uri.parse(api_link + "?api_key=" + api_key), body: {
      'oturumac': 'true',
      'kul_mail': mail,
      'kul_sifre': sifre,
    });

    if (sonuc.statusCode == 200) {
      Map<String, dynamic> gelen = jsonDecode(sonuc.body);

      if (gelen['durum'] == "ok") {
        Kullanici kullanici = Kullanici.fromJson(gelen['bilgiler']);
        print(kullanici.kulIsim);
        print(gelen);
        alt_mesaj(context, "oturum_ok".tr, tur: 1);
        await box.write("kul", gelen['bilgiler']);

        return true;
      } else {
        alt_mesaj(context, gelen['mesaj']);
        return false;
      }
    } else {
      alt_mesaj(context, 'islem_hata'.tr);
      return false;
    }
  }
}
