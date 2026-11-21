class Kitap {
  final int? id;
  final String ad;
  final String yazar;
  final int sayfaSayisi;
  final String? isbn;
  final String? kapakUrl;
  final String raf;
  final String eklenmeTarihi;

  const Kitap({
    this.id,
    required this.ad,
    required this.yazar,
    required this.sayfaSayisi,
    this.isbn,
    this.kapakUrl,
    this.raf = 'okunacak',
    required this.eklenmeTarihi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ad': ad,
      'yazar': yazar,
      'sayfaSayisi': sayfaSayisi,
      'isbn': isbn,
      'kapakUrl': kapakUrl,
      'raf': raf,
      'eklenmeTarihi': eklenmeTarihi,
    };
  }

  factory Kitap.fromMap(Map<String, dynamic> map) {
    return Kitap(
      id: map['id'] as int?,
      ad: map['ad'] as String,
      yazar: map['yazar'] as String,
      sayfaSayisi: map['sayfaSayisi'] as int,
      isbn: map['isbn'] as String?,
      kapakUrl: map['kapakUrl'] as String?,
      raf: map['raf'] as String,
      eklenmeTarihi: map['eklenmeTarihi'] as String,
    );
  }
}