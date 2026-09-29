import 'package:flutter/material.dart';

import '../../../modul_05/models/task.dart';
import '../database/app_database.dart';
import '../database/repositories/task_repository_impl.dart';

class SqliteTaskScreen extends StatefulWidget {
  const SqliteTaskScreen({
    super.key,
  });

  @override
  State<SqliteTaskScreen> createState() =>
      _SqliteTaskScreenState();
}

class _SqliteTaskScreenState
    extends State<SqliteTaskScreen> {
  late final TaskRepositoryImpl _repository;

  List<Task> _tasks = <Task>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _repository = TaskRepositoryImpl(
      database: AppDatabase(),
    );

    _muatTugas();
  }

  Future<void> _muatTugas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<Task> hasil =
          await _repository.ambilSemua();

      if (!mounted) {
        return;
      }

      setState(() {
        _tasks = hasil;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _tambahTugas() async {
    final int nomor = _tasks.length + 1;

    final Task tugas = Task(
      id: 'sqlite-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Tugas SQLite $nomor',
      course: 'Pemrograman Perangkat Bergerak',
      createdAt: DateTime.now().toIso8601String(),
      prioritas: 2,
    );

    try {
      await _repository.tambah(tugas);
      await _muatTugas();
    } catch (e) {
      _pesan('Gagal menambahkan tugas: $e');
    }
  }

  Future<void> _ubahStatus(Task tugas) async {
    final Task tugasBaru = tugas.copyWith(
      done: !tugas.done,
    );

    try {
      await _repository.perbarui(tugasBaru);
      await _muatTugas();
    } catch (e) {
      _pesan('Gagal memperbarui tugas: $e');
    }
  }

  Future<void> _hapusTugas(String id) async {
    try {
      await _repository.hapus(id);
      await _muatTugas();
    } catch (e) {
      _pesan('Gagal menghapus tugas: $e');
    }
  }

  Future<void> _hapusSemua() async {
    try {
      await _repository.hapusSemua();
      await _muatTugas();
    } catch (e) {
      _pesan('Gagal menghapus semua tugas: $e');
    }
  }

  void _pesan(String pesan) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
      ),
    );
  }

  String _prioritas(int nilai) {
    switch (nilai) {
      case 1:
        return 'Tinggi';
      case 3:
        return 'Rendah';
      default:
        return 'Sedang';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite - Fase B'),
        actions: <Widget>[
          IconButton(
            onPressed: _muatTugas,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed:
                _tasks.isEmpty ? null : _hapusSemua,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _tambahTugas,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Terjadi kesalahan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _muatTugas,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_tasks.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data tugas di SQLite.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        final Task tugas = _tasks[index];

        return Card(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: CheckboxListTile(
            value: tugas.done,
            onChanged: (_) {
              _ubahStatus(tugas);
            },
            title: Text(
              tugas.title,
              style: TextStyle(
                decoration: tugas.done
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Text(
              '${tugas.course}\n'
              'Prioritas: '
              '${_prioritas(tugas.prioritas)}',
            ),
            isThreeLine: true,
            secondary: IconButton(
              onPressed: () {
                _hapusTugas(tugas.id);
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
          ),
        );
      },
    );
  }
}