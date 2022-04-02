class ProjeModel {
  int? projeId;
  String? projeBaslik;
  String? projeDetay;
  String? projeTeslimTarihi;
  String? projeBaslamaTarihi;
  int? projeDurum;
  int? projeAciliyet;
  String? dosyaYolu;
  int? yuzde;

  ProjeModel(
      {this.projeId,
      this.projeBaslik,
      this.projeDetay,
      this.projeTeslimTarihi,
      this.projeBaslamaTarihi,
      this.projeDurum,
      this.projeAciliyet,
      this.dosyaYolu,
      this.yuzde});

  ProjeModel.fromJson(Map<String, dynamic> json) {
    projeId = json['proje_id'];
    projeBaslik = json['proje_baslik'];
    projeDetay = json['proje_detay'];
    projeTeslimTarihi = json['proje_teslim_tarihi'];
    projeBaslamaTarihi = json['proje_baslama_tarihi'];
    projeDurum = json['proje_durum'];
    projeAciliyet = json['proje_aciliyet'];
    dosyaYolu = json['dosya_yolu'];
    yuzde = json['yuzde'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['proje_id'] = this.projeId;
    data['proje_baslik'] = this.projeBaslik;
    data['proje_detay'] = this.projeDetay;
    data['proje_teslim_tarihi'] = this.projeTeslimTarihi;
    data['proje_baslama_tarihi'] = this.projeBaslamaTarihi;
    data['proje_durum'] = this.projeDurum;
    data['proje_aciliyet'] = this.projeAciliyet;
    data['dosya_yolu'] = this.dosyaYolu;
    data['yuzde'] = this.yuzde;
    return data;
  }
}
