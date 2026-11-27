import 'package:flutter/material.dart';

import 'kitaplik_ekrani.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _seciliSekme = 0;

  final List<Widget> _sayfalar = const [
    KitaplikEkrani(),
    _YakindaEkrani(baslik: 'Ara'),
    _YakindaEkrani(baslik: 'İlerleme'),
    _YakindaEkrani(baslik: 'Alıntılar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _seciliSekme, children: _sayfalar),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seciliSekme,
        onDestinationSelected: (index) {
          setState(() => _seciliSekme = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Kitaplığım',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Ara'),
          NavigationDestination(
            icon: Icon(Icons.schedule),
            label: 'İlerleme',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_quote),
            label: 'Alıntılar',
          ),
        ],
      ),
    );
  }
}

class _YakindaEkrani extends StatelessWidget {
  const _YakindaEkrani({required this.baslik});

  final String baslik;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(baslik)),
      body: const Center(child: Text('Bu ekran yakında eklenecek.')),
    );
  }
}