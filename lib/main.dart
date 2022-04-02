import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:istakip/dil.dart';
import 'package:istakip/sabitler/ext.dart';
import 'package:istakip/sayfalar/anasayfa.dart';
import 'package:istakip/sayfalar/oturum/giris.dart';
import 'package:window_size/window_size.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    setWindowMinSize(Size(500, 700));
    setWindowTitle("Aksoyhlc Sipariş-Proje Takip Programı");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    print(Get.locale);
    return GetMaterialApp(
      translations: Dil(),
      locale: box.read("dil") == null
          ? Get.deviceLocale
          : box.read("dil") == "tr"
              ? Dil.tr
              : Dil.en,
      fallbackLocale: Dil.varsayilan,
      debugShowCheckedModeBanner: false,
      home: oturum_kontrol() ? AnaSayfa() : GirisSayfasi(),
    );
  }
}
