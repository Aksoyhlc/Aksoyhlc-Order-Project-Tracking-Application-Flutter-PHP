import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:istakip/controller/genelController.dart';
import 'package:istakip/sayfalar/anasayfa.dart';
import 'package:istakip/sayfalar/siparis/siparis_duzenle.dart';

import '../sabitler/ext.dart';
import '../sayfalar/proje/proje_sayfasi.dart';
import '../sayfalar/proje/projeler.dart';
import '../sayfalar/siparis/siparisler.dart';

Widget bottomBar(BuildContext context) {
  GenelController controller = Get.find<GenelController>();
  return Obx(() => ConvexAppBar(
        backgroundColor: renk(arka_renk),
        items: [
          TabItem(icon: Icons.list_alt, title: 'projeler'.tr),
          TabItem(icon: Icons.add, title: 'proje_ekle'.tr),
          TabItem(icon: Icons.home, title: 'home'.tr),
          TabItem(icon: Icons.add, title: 'siparis_ekle'.tr),
          TabItem(icon: Icons.list_alt, title: 'siparisler'.tr),
        ],
        initialActiveIndex: controller.secilen_menu.value,
        onTabNotify: (int i) {
          if (i == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProjeSayfasi(ekle: true)));
            return false;
          } else if (i == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SiparisSayfasi(
                          ekleme: true,
                        )));
            return false;
          } else {
            return true;
          }
        },
        onTap: (int i) {
          print(i);
          if (i == 1 || i == 3) {
            controller.secilen_menu.value = 2;
          } else {
            controller.secilen_menu.value = i;
          }
          if (i == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProjelerSayfasi()));
          } else if (i == 1) {
          } else if (i == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnaSayfa()));
          } else if (i == 3) {
          } else if (i == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SiparislerSayfasi()));
          }
        },
      ));
}
