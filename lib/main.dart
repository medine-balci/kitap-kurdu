import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/kitap_provider.dart';
import 'screens/splash_ekrani.dart';
import 'services/ornek_veri.dart';

/// Uygulamanın ana renkleri. Rengi değiştirmek için sadece buraya bak.
const Color anaRenk = Color(0xFF345C4B);
const Color zeminRengi = Color(0xFFF6F3EC);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Veritabanı boşsa örnek kitaplar eklenir, ekran boş görünmez.
  await OrnekVeri.yukleGerekirse();
  runApp(
    ChangeNotifierProvider(
      create: (_) => KitapProvider()..yukle(),
      child: const KitapKurduUygulamasi(),
    ),
  );
}

class KitapKurduUygulamasi extends StatelessWidget {
  const KitapKurduUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitap Kurdu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: anaRenk),
        scaffoldBackgroundColor: zeminRengi,
        appBarTheme: const AppBarTheme(
          backgroundColor: zeminRengi,
          foregroundColor: anaRenk,
        ),
      ),
      home: const SplashEkrani(),
    );
  }
}