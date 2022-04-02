// To parse this JSON data, do
//
//     final kullanici = kullaniciFromJson(jsonString);

import 'dart:convert';

class Kullanici {
  Kullanici({
    this.kulId,
    this.kulIsim,
    this.kulMail,
    this.kulSifre,
    this.kulTelefon,
    this.kulUnvan,
    this.kulYetki,
    this.kulLogo,
    this.ipAdresi,
    this.sessionMail,
  });

  String? kulId;
  String? kulIsim;
  String? kulMail;
  String? kulSifre;
  String? kulTelefon;
  String? kulUnvan;
  String? kulYetki;
  String? kulLogo;
  String? ipAdresi;
  String? sessionMail;

  factory Kullanici.fromRawJson(String str) => Kullanici.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Kullanici.fromJson(Map<String, dynamic> json) => Kullanici(
        kulId: json["kul_id"],
        kulIsim: json["kul_isim"],
        kulMail: json["kul_mail"],
        kulSifre: json["kul_sifre"],
        kulTelefon: json["kul_telefon"],
        kulUnvan: json["kul_unvan"],
        kulYetki: json["kul_yetki"],
        kulLogo: json["kul_logo"],
        ipAdresi: json["ip_adresi"],
        sessionMail: json["session_mail"],
      );

  Map<String, dynamic> toJson() => {
        "kul_id": kulId,
        "kul_isim": kulIsim,
        "kul_mail": kulMail,
        "kul_sifre": kulSifre,
        "kul_telefon": kulTelefon,
        "kul_unvan": kulUnvan,
        "kul_yetki": kulYetki,
        "kul_logo": kulLogo,
        "ip_adresi": ipAdresi,
        "session_mail": sessionMail,
      };
}
