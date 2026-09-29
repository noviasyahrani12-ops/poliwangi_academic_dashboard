import '../../../modul_05/models/task.dart';
import 'repositories/task_repository.dart';

class TaskDatabaseService {
  final TaskRepository repository;

  const TaskDatabaseService({
    required this.repository,
  });

  Future<List<Task>> ambilSemua() {
    return repository.ambilSemua();
  }

  Future<void> tambah(Task tugas) {
    return repository.tambah(tugas);
  }

  Future<void> perbarui(Task tugas) {
    return repository.perbarui(tugas);
  }

  Future<void> hapus(String id) {
    return repository.hapus(id);
  }

  Future<void> hapusSemua() {
    return repository.hapusSemua();
  }

  Future<void> simpanSemua(List<Task> tugas) {
    return repository.simpanSemua(tugas);
  }
}