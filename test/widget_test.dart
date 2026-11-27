import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitap_kurdu/models/kitap.dart';
import 'package:kitap_kurdu/widgets/kitap_karti.dart';

void main() {
  testWidgets('Kitap kartı ad, yazar ve ilerleme yüzdesini gösterir',
      (WidgetTester tester) async {
    const kitap = Kitap(
      ad: 'Simyacı',
      yazar: 'Paulo Coelho',
      sayfaSayisi: 188,
      eklenmeTarihi: '2026-11-26',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KitapKarti(kitap: kitap, ilerleme: 0.5, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Simyacı'), findsOneWidget);
    expect(find.text('Paulo Coelho'), findsOneWidget);
    expect(find.text('%50'), findsOneWidget);
  });
}