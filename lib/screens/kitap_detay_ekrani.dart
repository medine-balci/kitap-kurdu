import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/alinti.dart';
import '../models/ilerleme.dart';
import '../models/kitap.dart';
import '../models/raflar.dart';
import '../providers/kitap_provider.dart';
import '../widgets/kapak_resmi.dart';

/// Tek bir kitabın bilgilerini, ilerlemesini ve alıntılarını gösterir.
class KitapDetayEkrani extends StatefulWidget {
  const KitapDetayEkrani({super.key, required this.kitapId});

  final int kitapId;

  @override
  State<KitapDetayEkrani> createState() => _KitapDetayEkraniState();
}

class _KitapDetayEkraniState extends State<KitapDetayEkrani> {
  late final Future<List<Alinti>> _alintilar;

  @override
  void initState() {
    super.initState();
    _alintilar = context.read<KitapProvider>().alintilariGetir(widget.kitapId);
  }

  Future<void> _sil() async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kitabı sil'),
        content: const Text('Bu kitap kitaplığından silinecek. Emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (onay != true || !mounted) return;
    final provider = context.read<KitapProvider>();
    Navigator.of(context).pop();
    await provider.kitapSil(widget.kitapId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KitapProvider>();
    final Kitap? kitap = provider.kitapBul(widget.kitapId);

    if (kitap == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kitap Detayı')),
        body: const Center(child: Text('Kitap bulunamadı.')),
      );
    }

    final sonSayfa = provider.sonSayfa(widget.kitapId);
    final oran = provider.ilerleme(kitap);
    final yuzde = ilerlemeYuzdesi(sonSayfa, kitap.sayfaSayisi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Detayı'),
        actions: [
          IconButton(
            onPressed: _sil,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Kitabı sil',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KapakResmi(url: kitap.kapakUrl, genislik: 100, yukseklik: 140),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kitap.ad,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(kitap.yazar),
                    const SizedBox(height: 4),
                    Text('${kitap.sayfaSayisi} sayfa'),
                    if (kitap.isbn != null && kitap.isbn!.isNotEmpty)
                      Text('ISBN: ${kitap.isbn}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Raf', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final raf in Raflar.tumu)
                ChoiceChip(
                  label: Text(Raflar.etiket(raf)),
                  selected: kitap.raf == raf,
                  onSelected: (_) => provider.rafDegistir(kitap, raf),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Okuma ilerlemesi  %$yuzde',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: oran),
                  const SizedBox(height: 8),
                  Text('$sonSayfa / ${kitap.sayfaSayisi} sayfa'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Alıntılar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<List<Alinti>>(
            future: _alintilar,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text('Alıntılar yüklenemedi.');
              }
              final alintilar = snapshot.data ?? [];
              if (alintilar.isEmpty) {
                return const Text('Bu kitap için henüz alıntı yok.');
              }
              return Column(
                children: [
                  for (final alinti in alintilar)
                    Card(
                      child: ListTile(
                        title: Text(alinti.metin),
                        subtitle: Text('Sayfa ${alinti.sayfa}'),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
