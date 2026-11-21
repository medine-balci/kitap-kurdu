class Alinti {
  final int? id;
  final int kitapId;
  final String metin;
  final String? fotoYolu;
  final int sayfa;
  final String tarih;

  const Alinti({
    this.id,
    required this.kitapId,
    required this.metin,
    this.fotoYolu,
    required this.sayfa,
    required this.tarih,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kitapId': kitapId,
      'metin': metin,
      'fotoYolu': fotoYolu,
      'sayfa': sayfa,
      'tarih': tarih,
    };
  }

  factory Alinti.fromMap(Map<String, dynamic> map) {
    return Alinti(
      id: map['id'] as int?,
      kitapId: map['kitapId'] as int,
      metin: map['metin'] as String,
      fotoYolu: map['fotoYolu'] as String?,
      sayfa: map['sayfa'] as int,
      tarih: map['tarih'] as String,
    );
  }
}