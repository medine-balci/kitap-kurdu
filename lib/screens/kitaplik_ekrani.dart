import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/raflar.dart';
import '../providers/kitap_provider.dart';
import '../widgets/kitap_karti.dart';
import 'kitap_detay_ekrani.dart';

class KitaplikEkrani extends StatelessWidget {
  const KitaplikEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KitapProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Kitap Kurdu')),
      body: Column(
        children: [
          _RafFiltresi(
            seciliRaf: provider.seciliRaf,
            onSecildi: provider.rafSec,
          ),
          Expanded(child: _Icerik(provider: provider)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kitap ekleme ekranı Modül A ile gelecek.'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RafFiltresi extends StatelessWidget {
  const _RafFiltresi({required this.seciliRaf, required this.onSecildi});

  final String? seciliRaf;
  final ValueChanged<String?> onSecildi;

  @override
  Widget build(BuildContext context) {
    final secenekler = <String?>[null, ...Raflar.tumu];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final raf in secenekler)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(raf == null ? 'Tümü' : Raflar.etiket(raf)),
                selected: seciliRaf == raf,
                onSelected: (_) => onSecildi(raf),
              ),
            ),
        ],
      ),
    );
  }
}

class _Icerik extends StatelessWidget {
  const _Icerik({required this.provider});

  final KitapProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.yukleniyor && provider.kitaplar.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.hata != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.hata!),
            TextButton(
              onPressed: provider.yukle,
              child: const Text('Tekrar dene'),
            ),
          ],
        ),
      );
    }
    final kitaplar = provider.kitaplar;
    if (kitaplar.isEmpty) {
      return const Center(child: Text('Bu rafta kitap yok.'));
    }
    return ListView.builder(
      itemCount: kitaplar.length,
      itemBuilder: (context, index) {
        final kitap = kitaplar[index];
        return KitapKarti(
          kitap: kitap,
          ilerleme: provider.ilerleme(kitap),
          onTap: () {
            final id = kitap.id;
            if (id == null) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => KitapDetayEkrani(kitapId: id),
              ),
            );
          },
        );
      },
    );
  }
}
