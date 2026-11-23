import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/alinti.dart';
import '../models/kitap.dart';
import '../models/okuma_kaydi.dart';

class VeritabaniServisi {
  VeritabaniServisi._();
  static final VeritabaniServisi instance = VeritabaniServisi._();

  static Database? _db;

  Future<Database> get veritabani async {
    _db ??= await _ac();
    return _db!;
  }

  Future<Database> _ac() async {
    final yol = join(await getDatabasesPath(), 'kitap_kurdu.db');
    return openDatabase(
      yol,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kitap (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ad TEXT NOT NULL,
            yazar TEXT NOT NULL,
            sayfaSayisi INTEGER NOT NULL,
            isbn TEXT,
            kapakUrl TEXT,
            raf TEXT NOT NULL,
            eklenmeTarihi TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE okuma_kaydi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kitapId INTEGER NOT NULL,
            kaldigiSayfa INTEGER NOT NULL,
            tarih TEXT NOT NULL,
            FOREIGN KEY (kitapId) REFERENCES kitap (id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE alinti (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kitapId INTEGER NOT NULL,
            metin TEXT NOT NULL,
            fotoYolu TEXT,
            sayfa INTEGER NOT NULL,
            tarih TEXT NOT NULL,
            FOREIGN KEY (kitapId) REFERENCES kitap (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<int> kitapEkle(Kitap kitap) async {
    final db = await veritabani;
    return db.insert('kitap', kitap.toMap());
  }

  Future<List<Kitap>> kitaplariGetir({String? raf}) async {
    final db = await veritabani;
    final satirlar = await db.query(
      'kitap',
      where: raf == null ? null : 'raf = ?',
      whereArgs: raf == null ? null : [raf],
      orderBy: 'id DESC',
    );
    return satirlar.map(Kitap.fromMap).toList();
  }

  Future<int> kitapGuncelle(Kitap kitap) async {
    final db = await veritabani;
    return db.update(
      'kitap',
      kitap.toMap(),
      where: 'id = ?',
      whereArgs: [kitap.id],
    );
  }

  Future<int> kitapSil(int id) async {
    final db = await veritabani;
    return db.delete('kitap', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> okumaKaydiEkle(OkumaKaydi kayit) async {
    final db = await veritabani;
    return db.insert('okuma_kaydi', kayit.toMap());
  }

  Future<OkumaKaydi?> sonOkumaKaydi(int kitapId) async {
    final db = await veritabani;
    final satirlar = await db.query(
      'okuma_kaydi',
      where: 'kitapId = ?',
      whereArgs: [kitapId],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (satirlar.isEmpty) return null;
    return OkumaKaydi.fromMap(satirlar.first);
  }

  Future<int> alintiEkle(Alinti alinti) async {
    final db = await veritabani;
    return db.insert('alinti', alinti.toMap());
  }

  Future<List<Alinti>> alintilariGetir({int? kitapId}) async {
    final db = await veritabani;
    final satirlar = await db.query(
      'alinti',
      where: kitapId == null ? null : 'kitapId = ?',
      whereArgs: kitapId == null ? null : [kitapId],
      orderBy: 'id DESC',
    );
    return satirlar.map(Alinti.fromMap).toList();
  }

  Future<int> alintiSil(int id) async {
    final db = await veritabani;
    return db.delete('alinti', where: 'id = ?', whereArgs: [id]);
  }
    Future<Kitap?> kitapGetir(int id) async {
    final db = await veritabani;
    final satirlar = await db.query('kitap', where: 'id = ?', whereArgs: [id]);
    return satirlar.isEmpty ? null : Kitap.fromMap(satirlar.first);
  }

  Future<List<OkumaKaydi>> okumaKayitlariniGetir(int kitapId) async {
    final db = await veritabani;
    final satirlar = await db.query(
      'okuma_kaydi',
      where: 'kitapId = ?',
      whereArgs: [kitapId],
      orderBy: 'id DESC',
    );
    return satirlar.map(OkumaKaydi.fromMap).toList();
  }
}