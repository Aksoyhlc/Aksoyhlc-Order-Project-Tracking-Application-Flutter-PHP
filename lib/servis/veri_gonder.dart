import 'dart:convert';

import 'package:dio/dio.dart' as di;
import 'package:get/get.dart';

import '../sabitler/ext.dart';

class VeriGonder {
  di.Dio dio = di.Dio();
  Future<Map> projeKaydet(Map<String, dynamic> bilgiler, int projeId, {bool ekleme: false}) async {
    if (ekleme) {
      bilgiler['projeekle'] = "projeekle";
    } else {
      bilgiler['projeguncelle'] = "projeguncelle";
      bilgiler['proje_id'] = projeId.toString();
    }

    if (bilgiler['dosya'].toString().length > 10) {
      bilgiler['proje_dosya'] = await di.MultipartFile.fromFile(bilgiler['dosya']);
    }

    di.FormData deger = di.FormData.fromMap(bilgiler);

    di.Response sonuc = await dio.post(
      api_link + "?api_key=" + api_key,
      data: deger,
      onSendProgress: (count, total) {
        print(count.toString() + " - " + total.toString());
      },
    );

    if (sonuc.statusCode == 200) {
      Map<String, dynamic> gelen = jsonDecode(sonuc.data);
      return gelen;
    } else {
      return {'durum': 'no', 'mesaj': 'islem_hata'.tr};
    }
  }

  Future<Map> siparisKaydet(Map<String, dynamic> bilgiler, int sipId, {bool ekleme: false}) async {
    if (ekleme) {
      bilgiler['siparisekle'] = "siparisekle";
    } else {
      bilgiler['siparisguncelle'] = "siparisguncelle";
      bilgiler['sip_id'] = sipId.toString();
    }

    if (bilgiler['dosya'].toString().length > 10) {
      bilgiler['sip_dosya'] = await di.MultipartFile.fromFile(bilgiler['dosya']);
    }

    di.FormData deger = di.FormData.fromMap(bilgiler);

    di.Response sonuc = await dio.post(
      api_link + "?api_key=" + api_key,
      data: deger,
      onSendProgress: (count, total) {
        print(count.toString() + " - " + total.toString());
      },
    );

    if (sonuc.statusCode == 200) {
      Map<String, dynamic> gelen = jsonDecode(sonuc.data);
      return gelen;
    } else {
      return {'durum': 'no', 'mesaj': 'islem_hata'.tr};
    }
  }

  Future<Map> projeSil(int projeId) async {
    print("XXXX");
    di.FormData deger = di.FormData.fromMap({'proje_id': projeId, 'projesilme': 'true'});

    di.Response sonuc = await dio.post(
      api_link + "?api_key=" + api_key,
      data: deger,
    );

    if (sonuc.statusCode == 200) {
      Map<String, dynamic> gelen = jsonDecode(sonuc.data);
      return gelen;
    } else {
      return {'durum': 'no', 'mesaj': 'islem_hata'.tr};
    }
  }

  Future<Map> siparisSil(int sipId) async {
    print("XXXX");
    di.FormData deger = di.FormData.fromMap({'sip_id': sipId, 'siparissilme': 'true'});

    di.Response sonuc = await dio.post(
      api_link + "?api_key=" + api_key,
      data: deger,
    );

    if (sonuc.statusCode == 200) {
      Map<String, dynamic> gelen = jsonDecode(sonuc.data);
      return gelen;
    } else {
      return {'durum': 'no', 'mesaj': 'islem_hata'.tr};
    }
  }
}
