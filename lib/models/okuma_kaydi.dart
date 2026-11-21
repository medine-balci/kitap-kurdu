class OkumaKaydi {
  final int? id;
  final int kitapId;
  final int kaldigiSayfa;
  final String tarih;

  const OkumaKaydi({
    this.id,
    required this.kitapId,
    required this.kaldigiSayfa,
    required this.tarih,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kitapId': kitapId,
      'kaldigiSayfa': kaldigiSayfa,
      'tarih': tarih,
    };
  }

  factory OkumaKaydi.fromMap(Map<String, dynamic> map) {
    return OkumaKaydi(
      id: map['id'] as int?,
      kitapId: map['kitapId'] as int,
      kaldigiSayfa: map['kaldigiSayfa'] as int,
      tarih: map['tarih'] as String,
    );
  }
}