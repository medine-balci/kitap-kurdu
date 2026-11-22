import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/kitap.dart';

class KitapApiServisi {
  static const String _anaAdres = 'https://openlibrary.org';
  static const Map<String, String> _basliklar = {
    'User-Agent': 'KitapKurdu/1.0 (ogrenci projesi)',
  };

  Future<List<Kitap>> kitapAra(String arama) async {
    final sorgu = arama.trim();
    if (sorgu.isEmpty) return [];
    return _getir({'q': sorgu});
  }

  Future<Kitap?> isbnIleBul(String isbn) async {
    final temiz = isbn.replaceAll(RegExp(r'[^0-9Xx]'), '');
    if (temiz.isEmpty) return null;
    final sonuclar = await _getir({'isbn': temiz});
    return sonuclar.isEmpty ? null : sonuclar.first;
  }

  Future<List<Kitap>> _getir(Map<String, String> sorgu) async {
    final adres = Uri.parse('$_anaAdres/search.json').replace(
      queryParameters: {
        ...sorgu,
        'fields': 'title,author_name,number_of_pages_median,cover_i,isbn',
        'limit': '20',
      },
    );

    final cevap = await http
        .get(adres, headers: _basliklar)
        .timeout(const Duration(seconds: 15));

    if (cevap.statusCode != 200) {
      throw Exception('Open Library hatası: ${cevap.statusCode}');
    }

    final veri =
        jsonDecode(utf8.decode(cevap.bodyBytes)) as Map<String, dynamic>;
    final liste = veri['docs'] as List<dynamic>? ?? [];
    return liste
        .map((e) => _kitapOlustur(e as Map<String, dynamic>))
        .toList();
  }

  Kitap _kitapOlustur(Map<String, dynamic> json) {
    final yazarlar = json['author_name'] as List<dynamic>?;
    final isbnler = json['isbn'] as List<dynamic>?;
    final kapak = json['cover_i'];

    return Kitap(
      ad: (json['title'] as String?) ?? 'Adsız kitap',
      yazar: (yazarlar != null && yazarlar.isNotEmpty)
          ? yazarlar.first as String
          : 'Bilinmeyen yazar',
      sayfaSayisi: (json['number_of_pages_median'] as int?) ?? 0,
      isbn: (isbnler != null && isbnler.isNotEmpty)
          ? isbnler.first as String
          : null,
      kapakUrl: kapak == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$kapak-M.jpg',
      eklenmeTarihi: DateTime.now().toIso8601String(),
    );
  }
}