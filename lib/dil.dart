import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Dil extends Translations {
  static final en = Locale("en", "US");
  static final tr = Locale("tr", "TR");
  static final varsayilan = tr;
  static final diller = [tr, en];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'giris': 'Login',
          'sifre_girin': "Enter your password",
          'mail_girin': "Enter your E-Mail",
          'son_projeler': "Recent Projects",
          'tum_projeler': "All Projects",
          'tum_siparisler': "All Orders",
          'son_siparisler': "Last Orders",
          'proje_detay': "Project Detail",
          'siparis_detay': "Order Detail",
          'proje_duzenle': "Edit Project",
          'siparis_duzenle': "Edit Order",
          'siparis_ekle': "Add Order",
          'projeler': "Projects",
          'siparisler': "Orders",
          'proje_ekle': "Add Project",
          'baslangic': "Start Date",
          'bitis': "End Date",
          'aciliyet': "Urgency",
          'durum': "Status",
          'yuzde': "Percent",
          'indir': "Download File",
          'paylas': "Share",
          'kapat': "Close",
          'yukle': "Upload File",
          'musteri_bilgileri': "Customer Info",
          'isim': "Name Surname",
          'telefon': "Phone",
          'ucret': "Order Fee",
          'sip_kayit_ok': "Your order has been registered",
          'proje_kayit_ok': "Your project has been registered",
          'baslik_bos': "Title Field Cannot Be Empty",
          'oturum_ok': 'Login Successful',
          'islem_hata': "We Can't Process Your Transaction Right Now, Please Try Again Later",
          'home': "Home",
          'baslik': "Field",
          'dil_secin': "Select Language",
          'dil_degisti': "Language Successfully Changed"
        },
        'tr_TR': {
          'giris': 'Giriş Yap',
          'sifre_girin': "Şifrenizi Girin",
          'mail_girin': "E-Posta Adresinizi Girin",
          'son_projeler': "Son Projeler",
          'tum_projeler': "Tüm Projeler",
          'tum_siparisler': "Tüm Siparişler",
          'son_siparisler': "Tüm Siparişler",
          'proje_detay': "Proje Detayı",
          'proje_duzenle': "Proje Düzenle",
          'siparis_duzenle': "Sipariş Düzenle",
          'siparis_ekle': "Sipariş Ekle",
          'projeler': "Projeler",
          'siparisler': "Siparişler",
          'proje_ekle': "Proje Ekle",
          'baslangic': "Başangıç Tarihi:",
          'bitis': "Bitiş Tarihi:",
          'aciliyet': "Aciliyet:",
          'durum': "Durum:",
          'yuzde': "Yüzde:",
          'indir': "Dosyayı İndir",
          'paylas': "Paylaş",
          'kapat': "Kapat",
          'yukle': "Dosya Yükle",
          'musteri_bilgileri': "Müşteri Bilgileri",
          'isim': "İsim Soyisim",
          'telefon': "Telefon",
          'ucret': "Sipariş Ücreti",
          'sip_kayit_ok': "Siparişiniz Kayıt Edildi",
          'proje_kayit_ok': "Projeniz Kayıt Edildi",
          'baslik_bos': "Başlık Alanı Boş Olamaz",
          'oturum_ok': 'Oturum Açma İşlemi Başarılı',
          'islem_hata': "İşleminizi Şu Anda Gerçekleştiremiyoruz, Lütfen Daha Sonra Tekrar Deneyin",
          'home': "Ana Sayfa",
          'baslik': "Başlık",
          'siparis_detay': "Sipariş Detayı",
          'dil_secin': "Dil Seçin",
          'dil_degisti': "Dil Başarıyla Değiştirildi"
        }
      };
}
