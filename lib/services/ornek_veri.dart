import '../models/alinti.dart';
import '../models/kitap.dart';
import '../models/okuma_kaydi.dart';
import '../models/raflar.dart';
import 'veritabani_servisi.dart';

class OrnekVeri {
  static Future<void> yukleGerekirse() async {
    final servis = VeritabaniServisi.instance;
    final mevcut = await servis.kitaplariGetir();
    if (mevcut.isNotEmpty) return;

    final simdi = DateTime.now().toIso8601String();

    final sucVeCezaId = await servis.kitapEkle(Kitap(
      ad: 'Suç ve Ceza',
      yazar: 'Fyodor Dostoyevski',
      sayfaSayisi: 672,
      raf: Raflar.okunuyor,
      eklenmeTarihi: simdi,
    ));

    await servis.kitapEkle(Kitap(
      ad: 'Simyacı',
      yazar: 'Paulo Coelho',
      sayfaSayisi: 188,
      raf: Raflar.okunacak,
      eklenmeTarihi: simdi,
    ));

    await servis.kitapEkle(Kitap(
      ad: 'Sefiller',
      yazar: 'Victor Hugo',
      sayfaSayisi: 1400,
      raf: Raflar.okunacak,
      eklenmeTarihi: simdi,
    ));

    final madonnaId = await servis.kitapEkle(Kitap(
      ad: 'Kürk Mantolu Madonna',
      yazar: 'Sabahattin Ali',
      sayfaSayisi: 160,
      raf: Raflar.bitti,
      eklenmeTarihi: simdi,
    ));

    await servis.okumaKaydiEkle(
      OkumaKaydi(kitapId: sucVeCezaId, kaldigiSayfa: 403, tarih: simdi),
    );
    await servis.okumaKaydiEkle(
      OkumaKaydi(kitapId: madonnaId, kaldigiSayfa: 160, tarih: simdi),
    );

    await servis.alintiEkle(Alinti(
      kitapId: sucVeCezaId,
      metin: 'Örnek alıntı: bu metin uygulamayı denemek için eklenmiştir.',
      sayfa: 45,
      tarih: simdi,
    ));
  }
}