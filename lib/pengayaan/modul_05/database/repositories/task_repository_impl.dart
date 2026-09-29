import 'package:sqflite/sqflite.dart';

import '../../../../modul_05/models/task.dart';
import '../app_database.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase database;

  const TaskRepositoryImpl({
    required this.database,
  });

  @override
  Future<List<Task>> ambilSemua() async {
    final Database db = await database.basisData;

    final List<Map<String, Object?>> hasil = await db.query(
      AppDatabase.tabelTugas,
      orderBy: 'dibuat_pada DESC',
    );

    return hasil
        .map(TaskRepositoryImpl._dariBaris)
        .toList(growable: true);
  }

  @override
  Future<void> simpanSemua(List<Task> tugas) async {
    final Database db = await database.basisData;

    await db.transaction((Transaction tx) async {
      await tx.delete(AppDatabase.tabelTugas);

      for (final Task tugasItem in tugas) {
        await tx.insert(
          AppDatabase.tabelTugas,
          _keBaris(tugasItem),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> tambah(Task tugas) async {
    final Database db = await database.basisData;

    await db.insert(
      AppDatabase.tabelTugas,
      _keBaris(tugas),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> perbarui(Task tugas) async {
    final Database db = await database.basisData;

    await db.update(
      AppDatabase.tabelTugas,
      _keBaris(tugas),
      where: 'id = ?',
      whereArgs: <Object?>[tugas.id],
    );
  }

  @override
  Future<void> hapus(String id) async {
    final Database db = await database.basisData;

    await db.delete(
      AppDatabase.tabelTugas,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  @override
  Future<void> hapusSemua() async {
    final Database db = await database.basisData;

    await db.delete(AppDatabase.tabelTugas);
  }

  static Map<String, Object?> _keBaris(Task tugas) {
    return <String, Object?>{
      'id': tugas.id,
      'judul': tugas.title,
      'mata_kuliah': tugas.course,
      'selesai': tugas.done ? 1 : 0,
      'dibuat_pada': tugas.createdAt,
      'prioritas': tugas.prioritas,
    };
  }

  static Task _dariBaris(
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