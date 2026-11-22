import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/alinti.dart';
import '../models/kitap.dart';
import '../models/okuma_kaydi.dart';

/// Tüm SQLite işlemleri yalnızca bu serviste yapılır.
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _dbName = 'kitap_kurdu.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kitaplar (
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
      CREATE TABLE okuma_kayitlari (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kitapId INTEGER NOT NULL,
        sayfa INTEGER NOT NULL,
        tarih TEXT NOT NULL,
        FOREIGN KEY (kitapId) REFERENCES kitaplar (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE alintilar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kitapId INTEGER NOT NULL,
        metin TEXT,
        fotoYolu TEXT,
        sayfa INTEGER,
        tarih TEXT NOT NULL,
        FOREIGN KEY (kitapId) REFERENCES kitaplar (id) ON DELETE CASCADE
      )
    ''');
  }

  // ---------- KİTAP ----------

  Future<int> kitapEkle(Kitap kitap) async {
    final db = await database;
    return db.insert('kitaplar', kitap.toMap());
  }

  Future<List<Kitap>> kitaplariGetir({String? raf}) async {
    final db = await database;
    final rows = await db.query(
      'kitaplar',
      where: raf == null ? null : 'raf = ?',
      whereArgs: raf == null ? null : [raf],
      orderBy: 'eklenmeTarihi DESC',
    );
    return rows.map(Kitap.fromMap).toList();
  }

  Future<Kitap?> kitapGetir(int id) async {
    final db = await database;
    final rows = await db.query('kitaplar', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Kitap.fromMap(rows.first);
  }

  Future<int> kitapGuncelle(Kitap kitap) async {
    final db = await database;
    return db.update(
      'kitaplar',
      kitap.toMap(),
      where: 'id = ?',
      whereArgs: [kitap.id],
    );
  }

  Future<int> kitapSil(int id) async {
    final db = await database;
    return db.delete('kitaplar', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- OKUMA KAYDI ----------

  Future<int> okumaKaydiEkle(OkumaKaydi kayit) async {
    final db = await database;
    return db.insert('okuma_kayitlari', kayit.toMap());
  }

  Future<List<OkumaKaydi>> okumaKayitlariniGetir(int kitapId) async {
    final db = await database;
    final rows = await db.query(
      'okuma_kayitlari',
      where: 'kitapId = ?',
      whereArgs: [kitapId],
      orderBy: 'tarih DESC',
    );
    return rows.map(OkumaKaydi.fromMap).toList();
  }

  // ---------- ALINTI ----------

  Future<int> alintiEkle(Alinti alinti) async {
    final db = await database;
    return db.insert('alintilar', alinti.toMap());
  }

  /// kitapId verilirse o kitabın, verilmezse tüm alıntılar gelir.
  Future<List<Alinti>> alintilariGetir({int? kitapId}) async {
    final db = await database;
    final rows = await db.query(
      'alintilar',
      where: kitapId == null ? null : 'kitapId = ?',
      whereArgs: kitapId == null ? null : [kitapId],
      orderBy: 'tarih DESC',
    );
    return rows.map(Alinti.fromMap).toList();
  }

  Future<int> alintiSil(int id) async {
    final db = await database;
    return db.delete('alintilar', where: 'id = ?', whereArgs: [id]);
  }
}
