import 'package:flutter/material.dart';

class KapakResmi extends StatelessWidget {
  const KapakResmi({
    super.key,
    this.url,
    this.genislik = 48,
    this.yukseklik = 68,
  });

  final String? url;
  final double genislik;
  final double yukseklik;

  Widget _yedek(BuildContext context) {
    final renkler = Theme.of(context).colorScheme;
    return Container(
      width: genislik,
      height: yukseklik,
      decoration: BoxDecoration(
        color: renkler.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.menu_book, color: renkler.onPrimaryContainer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adres = url;
    if (adres == null || adres.isEmpty) return _yedek(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        adres,
        width: genislik,
        height: yukseklik,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _yedek(context),
      ),
    );
  }
}
