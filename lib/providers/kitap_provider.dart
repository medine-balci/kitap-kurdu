import 'package:flutter/foundation.dart';

import '../models/alinti.dart';
import '../models/ilerleme.dart';
import '../models/kitap.dart';
import '../services/veritabani_servisi.dart';

/// Kitap listesini, seçili rafı ve okuma ilerlemesini tutar.
/// Ekranlar veriyi veritabanından değil, buradan alır.
class KitapProvider extends ChangeNotifier {
  final VeritabaniServisi _servis = VeritabaniServisi.instance;

  List<Kitap> _tumKitaplar = [];
  final Map<int, int> _sonSayfalar = {};
  String? _seciliRaf;
  bool _yukleniyor = false;
  String? _hata;

  String? get seciliRaf => _seciliRaf;
  bool get yukleniyor => _yukleniyor;
  String? get hata => _hata;

  List<Kitap> get kitaplar {
    if (_seciliRaf == null) return List.unmodifiable(_tumKitaplar);
    return _tumKitaplar.where((k) => k.raf == _seciliRaf).toList();
  }

  Kitap? kitapBul(int id) {
    for (final kitap in _tumKitaplar) {
      if (kitap.id == id) return kitap;
    }
    return null;
  }

  int sonSayfa(int kitapId) => _sonSayfalar[kitapId] ?? 0;

  double ilerleme(Kitap kitap) {
    final id = kitap.id;
    if (id == null) return 0;
    return ilerlemeOrani(sonSayfa(id), kitap.sayfaSayisi);
  }

  Future<void> yukle() async {
    _yukleniyor = true;
    _hata = null;
    notifyListeners();
    try {
      _tumKitaplar = await _servis.kitaplariGetir();
      _sonSayfalar.clear();
      for (final kitap in _tumKitaplar) {
        final id = kitap.id;
        if (id == null) continue;
        final kayit = await _servis.sonOkumaKaydi(id);
        if (kayit != null) _sonSayfalar[id] = kayit.kaldigiSayfa;
      }
    } catch (e) {
      _hata = 'Kitaplar yüklenemedi: $e';
    }
    _yukleniyor = false;
    notifyListeners();
  }

  void rafSec(String? raf) {
    _seciliRaf = raf;
    notifyListeners();
  }

  Future<void> kitapEkle(Kitap kitap) async {
    await _servis.kitapEkle(kitap);
    await yukle();
  }

  Future<void> kitapSil(int id) async {
    await _servis.kitapSil(id);
    await yukle();
  }

  Future<void> rafDegistir(Kitap kitap, String yeniRaf) async {
    final guncel = Kitap(
      id: kitap.id,
      ad: kitap.ad,
      yazar: kitap.yazar,
      sayfaSayisi: kitap.sayfaSayisi,
      isbn: kitap.isbn,
      kapakUrl: kitap.kapakUrl,
      raf: yeniRaf,
      eklenmeTarihi: kitap.eklenmeTarihi,
    );
    await _servis.kitapGuncelle(guncel);
    await yukle();
  }

  Future<List<Alinti>> alintilariGetir(int kitapId) {
    return _servis.alintilariGetir(kitapId: kitapId);
  }
}
