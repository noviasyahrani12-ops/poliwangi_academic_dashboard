import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../../modul_05/models/task.dart';

class AppDatabase {
  static const String namaBerkas = 'poliwangi_tugas.db';
  static const String tabelTugas = 'tugas';
  static const int versiSkema = 2;

  static const String sqlBuatTabelV1 = '''
CREATE TABLE $tabelTugas (
  id TEXT PRIMARY KEY,
  judul TEXT NOT NULL,
  mata_kuliah TEXT NOT NULL,
  selesai INTEGER NOT NULL DEFAULT 0,
  dibuat_pada TEXT NOT NULL
)
''';

  static const String sqlMigrasiKeV2 =
      'ALTER TABLE $tabelTugas '
      'ADD COLUMN prioritas INTEGER NOT NULL DEFAULT 2';

  final String? _jalur;

  Database? _basisData;

  AppDatabase({
    String? jalur,
  }) : _jalur = jalur;

  Future<Database> get basisData async {
    final Database? tersimpan = _basisData;

    if (tersimpan != null) {
      return tersimpan;
    }

    final String dasar =
        _jalur ?? await getDatabasesPath();

    final String jalurDatabase =
        _jalur ?? p.join(dasar, namaBerkas);

    final Database dibuka = await openDatabase(
      jalurDatabase,
      version: versiSkema,
      onConfigure: _saatDikonfigurasi,
      onCreate: _saatDibuat,
      onUpgrade: _saatDinaikkan,
    );

    _basisData = dibuka;

    return dibuka;
  }

  static Future<void> _saatDikonfigurasi(
    Database db,
  ) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future<void> _saatDibuat(
    Database db,
    int versi,
  ) async {
    await db.execute('''
CREATE TABLE $tabelTugas (
  id TEXT PRIMARY KEY,
  judul TEXT NOT NULL,
  mata_kuliah TEXT NOT NULL,
  selesai INTEGER NOT NULL DEFAULT 0,
  dibuat_pada TEXT NOT NULL,
  prioritas INTEGER NOT NULL DEFAULT 2
)
''');
  }

  static Future<void> _saatDinaikkan(
    Database db,
    int versiLama,
    int versiBaru,
  ) async {
    if (versiLama < 2) {
      await db.execute(sqlMigrasiKeV2);
    }
  }

  Future<void> tutup() async {
    final Database? db = _basisData;

    if (db != null && db.isOpen) {
      await db.close();
    }

    _basisData = null;
  }

  Future<void> hapusDatabase() async {
    await tutup();

    final String dasar =
        _jalur ?? await getDatabasesPath();

    final String jalurDatabase =
        _jalur ?? p.join(dasar, namaBerkas);

    await deleteDatabase(jalurDatabase);
  }

  static Map<String, Object?> keBaris(Task tugas) {
    return <String, Object?>{
      'id': tugas.id,
      'judul': tugas.title,
      'mata_kuliah': tugas.course,
      'selesai': tugas.done ? 1 : 0,
      'dibuat_pada': tugas.createdAt,
      'prioritas': tugas.prioritas,
    };
  }

  static Task dariBaris(
    Map<String, Object?> baris,
  ) {
    return Task(
      id: baris['id']! as String,
      title: baris['judul']! as String,
      course: baris['mata_kuliah']! as String,
      done: (baris['selesai'] as int? ?? 0) == 1,
      createdAt: baris['dibuat_pada']! as String,
      prioritas: baris['prioritas'] as int? ?? 2,
    );
  }
}