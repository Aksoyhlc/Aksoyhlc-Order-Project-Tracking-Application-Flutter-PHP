class SiparisModel {
  int? sipId;
  String? musteriIsim;
  String? musteriMail;
  String? musteriTelefon;
  String? sipBaslik;
  String? sipTeslimTarihi;
  int? sipAciliyet;
  int? sipDurum;
  String? sipDetay;
  int? sipUcret;
  String? sipBaslamaTarih;
  String? dosyaYolu;
  int? yuzde;

  SiparisModel(
      {this.sipId,
      this.musteriIsim,
      this.musteriMail,
      this.musteriTelefon,
      this.sipBaslik,
      this.sipTeslimTarihi,
      this.sipAciliyet,
      this.sipDurum,
      this.sipDetay,
      this.sipUcret,
      this.sipBaslamaTarih,
      this.dosyaYolu,
      this.yuzde});

  SiparisModel.fromJson(Map<String, dynamic> json) {
    sipId = json['sip_id'];
    musteriIsim = json['musteri_isim'];
    musteriMail = json['musteri_mail'];
    musteriTelefon = json['musteri_telefon'].toString();
    sipBaslik = json['sip_baslik'];
    sipTeslimTarihi = json['sip_teslim_tarihi'];
    sipAciliyet = json['sip_aciliyet'];
    sipDurum = json['sip_durum'];
    sipDetay = json['sip_detay'];
    sipUcret = json['sip_ucret'];
    sipBaslamaTarih = json['sip_baslama_tarih'];
    dosyaYolu = json['dosya_yolu'];
    yuzde = json['yuzde'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sip_id'] = this.sipId;
    data['musteri_isim'] = this.musteriIsim;
    data['musteri_mail'] = this.musteriMail;
    data['musteri_telefon'] = this.musteriTelefon.toString();
    data['sip_baslik'] = this.sipBaslik;
    data['sip_teslim_tarihi'] = this.sipTeslimTarihi;
    data['sip_aciliyet'] = this.sipAciliyet;
    data['sip_durum'] = this.sipDurum;
    data['sip_detay'] = this.sipDetay;
    data['sip_ucret'] = this.sipUcret;
    data['sip_baslama_tarih'] = this.sipBaslamaTarih;
    data['dosya_yolu'] = this.dosyaYolu;
    data['yuzde'] = this.yuzde;
    return data;
  }
}
