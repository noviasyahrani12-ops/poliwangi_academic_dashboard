import '../../../../modul_05/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> ambilSemua();

  Future<void> simpanSemua(List<Task> tugas);

  Future<void> tambah(Task tugas);

  Future<void> perbarui(Task tugas);

  Future<void> hapus(String id);

  Future<void> hapusSemua();
}