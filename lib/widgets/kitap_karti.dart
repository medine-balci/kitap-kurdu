import 'package:flutter/material.dart';

import '../models/kitap.dart';
import 'kapak_resmi.dart';

class KitapKarti extends StatelessWidget {
  const KitapKarti({
    super.key,
    required this.kitap,
    required this.ilerleme,
    required this.onTap,
  });

  final Kitap kitap;
  final double ilerleme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final yuzde = (ilerleme * 100).round();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              KapakResmi(url: kitap.kapakUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kitap.ad,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      kitap.yazar,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: ilerleme),
                    const SizedBox(height: 4),
                    Text('%$yuzde'),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
