import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:istakip/model/proje_model.dart';
import 'package:istakip/model/siparis_model.dart';

import '../sabitler/ext.dart';

class VeriGetir {
  GetStorage box = GetStorage();

  Future<Map> istek(int tur, {String order: "", String limit: ""}) async {
    Map param = {};

    if (tur == 0) {
      param = {'projeleri_getir': 'true'};
    } else if (tur == 1) {
      param = {'siparisleri_getir': 'true'};
    }

    if (limit.isNotEmpty) {
      param['limit'] = limit;
    }

    if (order.isNotEmpty) {
      param['sirala'] = order;
    }

    http.Response sonuc = await http.post(Uri.parse(api_link + "?api_key=" + api_key), body: param);

    if (sonuc.statusCode == 200) {
      Map<String, dynamic> gelen = jsonDecode(sonuc.body);
      return gelen;
    } else {
      return {'durum': 'no', 'mesaj': 'Bağlantı İşlemi Başarısız'};
    }
  }

  Future<List> projeleri_getir({String order: "proje_id DESC", String limit: "3"}) async {
    Map veri = await istek(0, limit: limit, order: order);
    List<ProjeModel> projeler = [];
    if (veri['durum'] == 'ok') {
      for (var element in veri['projeler']) {
        projeler.add(ProjeModel.fromJson(element));
      }

      return [true, projeler];
    } else {
      return [false, veri['mesaj']];
    }
  }

  Future<List> siparisleri_getir({String order: "sip_id DESC", String limit: "3"}) async {
    try {
      Map veri = await istek(1, order: order, limit: limit);
      List<SiparisModel> siparisler = [];
      if (veri['durum'] == 'ok') {
        for (Map<String, dynamic> element in veri['siparisler']) {
          siparisler.add(SiparisModel.fromJson(element));
        }

        return [true, siparisler];
      } else {
        return [false, veri['mesaj']];
      }
    } catch (e) {
      print(e.toString());
      return [false, "İşlem Başarısız"];
    }
  }
}
