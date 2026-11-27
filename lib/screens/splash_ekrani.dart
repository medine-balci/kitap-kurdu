import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import 'ana_sayfa.dart';

class SplashEkrani extends StatefulWidget {
  const SplashEkrani({super.key});

  @override
  State<SplashEkrani> createState() => _SplashEkraniState();
}

class _SplashEkraniState extends State<SplashEkrani> {
  Timer? _zamanlayici;

  @override
  void initState() {
    super.initState();
    _zamanlayici = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    });
  }

  @override
  void dispose() {
    _zamanlayici?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: anaRenk,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, size: 72, color: zeminRengi),
            SizedBox(height: 16),
            Text(
              'Kitap Kurdu',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: zeminRengi,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kitaplarını tek yerde takip et',
              style: TextStyle(color: zeminRengi),
            ),
          ],
        ),
      ),
    );
  }
}