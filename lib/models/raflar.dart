class Raflar {
  static const String okunacak = 'okunacak';
  static const String okunuyor = 'okunuyor';
  static const String bitti = 'bitti';

  static const List<String> tumu = [okunacak, okunuyor, bitti];

  static String etiket(String raf) {
    switch (raf) {
      case okunacak:
        return 'Okunacak';
      case okunuyor:
        return 'Okunuyor';
      case bitti:
        return 'Bitti';
      default:
        return raf;
    }
  }
}