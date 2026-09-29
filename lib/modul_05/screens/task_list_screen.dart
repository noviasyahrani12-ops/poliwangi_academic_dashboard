import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
    this.storage,
  });

  final TaskStorage? storage;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskStorage _storage =
      widget.storage ?? const TaskStorage();

  List<Task>? _tasks;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // =========================
  // MEMUAT DATA
  // =========================

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<Task> tasks = await _storage.muat();

      if (!mounted) return;

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _tasks = null;
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  // =========================
  // MENYIMPAN DATA
  // =========================

  Future<bool> _saveTasks(List<Task> tasks) async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _storage.simpan(tasks);

      if (!mounted) return false;

      setState(() {
        _tasks = tasks;
        _isSaving = false;
      });

      return true;
    } catch (error) {
      if (!mounted) return false;

      setState(() {
        _isSaving = false;
      });

      _showMessage(
        'Gagal menyimpan data: $error',
      );

      return false;
    }
  }

  // =========================
  // CHECKLIST TUGAS
  // =========================

  Future<void> _toggleTask(Task task) async {
    if (_tasks == null) return;

    final List<Task> updatedTasks = _tasks!.map((Task item) {
      if (item.id == task.id) {
        return item.copyWith(
          done: !item.done,
        );
      }

      return item;
    }).toList();

    await _saveTasks(updatedTasks);
  }

  // =========================
  // TAMBAH TUGAS
  // =========================

  Future<void> _addTask() async {
    final TextEditingController titleController =
        TextEditingController();

    final TextEditingController courseController =
        TextEditingController();

    int selectedPriority = 2;

    final Task? newTask = await showDialog<Task>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            void Function(void Function()) setDialogState,
          ) {
            return AlertDialog(
              title: const Text('Tambah Tugas'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Tugas',
                        hintText: 'Contoh: Membuat laporan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: courseController,
                      decoration: const InputDecoration(
                        labelText: 'Mata Kuliah',
                        hintText: 'Contoh: Struktur Data',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Prioritas',
                        border: OutlineInputBorder(),
                      ),
                      items: const <DropdownMenuItem<int>>[
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Tinggi'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Sedang'),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text('Rendah'),
                        ),
                      ],
                      onChanged: (int? value) {
                        if (value == null) return;

                        setDialogState(() {
                          selectedPriority = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final String title =
                        titleController.text.trim();

                    final String course =
                        courseController.text.trim();

                    if (title.isEmpty || course.isEmpty) {
                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Judul dan mata kuliah harus diisi.',
                          ),
                        ),
                      );
                      return;
                    }

                    final Task task = Task(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      title: title,
                      course: course,
                      createdAt: DateTime.now()
                          .toIso8601String()
                          .substring(0, 10),
                      prioritas: selectedPriority,
                    );

                    Navigator.pop(
                      dialogContext,
                      task,
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    courseController.dispose();

    if (newTask == null) return;

    final List<Task> updatedTasks =
        List<Task>.of(_tasks ?? <Task>[]);

    updatedTasks.add(newTask);

    final bool success =
        await _saveTasks(updatedTasks);

    if (!mounted || !success) return;

    _showMessage(
      'Tugas berhasil ditambahkan.',
    );
  }

  // =========================
  // HAPUS TUGAS
  // =========================

  Future<void> _deleteTask(Task task) async {
    if (_tasks == null) return;

    final List<Task> updatedTasks =
        _tasks!.where((Task item) {
      return item.id != task.id;
    }).toList();

    final bool success =
        await _saveTasks(updatedTasks);

    if (!mounted || !success) return;

    _showMessage(
      'Tugas "${task.title}" berhasil dihapus.',
    );
  }

  // =========================
  // HAPUS SEMUA DATA
  // =========================

  Future<void> _deleteAllTasks() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Semua Data'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus semua tugas?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _storage.hapusSemua();

    if (!mounted) return;

    setState(() {
      _tasks = <Task>[];
      _errorMessage = null;
    });

    _showMessage(
      'Semua data berhasil dihapus.',
    );
  }

  // =========================
  // DEMO DATA RUSAK
  // =========================

  Future<void> _createBrokenData() async {
    await _storage.rusakkanUntukDemo();

    if (!mounted) return;

    _showMessage(
      'Data rusak berhasil dibuat untuk pengujian.',
    );

    await _loadTasks();
  }

  // =========================
  // PESAN
  // =========================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // =========================
  // TAMPILAN LOADING
  // =========================

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Memuat data tugas...',
          ),
        ],
      ),
    );
  }

  // =========================
  // TAMPILAN ERROR
  // =========================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data tugas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadTasks,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                await _storage.hapusSemua();

                if (!mounted) return;

                await _loadTasks();
              },
              child: const Text('Hapus Data Rusak'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // TAMPILAN KOSONG
  // =========================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.task_alt,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada tugas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tekan tombol + untuk menambahkan tugas.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _addTask,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Tugas'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // TAMPILAN DAFTAR
  // =========================

  Widget _buildTaskList() {
    final List<Task> tasks = _tasks!;

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final Task task = tasks[index];

          return Dismissible(
            key: ValueKey<String>(task.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Hapus Tugas'),
                    content: Text(
                      'Hapus tugas "${task.title}"?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            false,
                          );
                        },
                        child: const Text('Batal'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            true,
                          );
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (_) {
              _deleteTask(task);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(
                right: 24,
              ),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: TaskTile(
              task: task,
              onToggle: _toggleTask,
            ),
          );
        },
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tugas Praktikum',
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _loadTasks,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'hapus') {
                _deleteAllTasks();
              } else if (value == 'rusak') {
                _createBrokenData();
              }
            },
            itemBuilder: (
              BuildContext context,
            ) {
              return const <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'hapus',
                  child: Text(
                    'Hapus Semua Data',
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'rusak',
                  child: Text(
                    'Uji Data Rusak',
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (_isLoading)
            _buildLoading()
          else if (_errorMessage != null)
            _buildError()
          else if (_tasks == null || _tasks!.isEmpty)
            _buildEmpty()
          else
            _buildTaskList(),

          if (_isSaving)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LinearProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isSaving ? null : _addTask,
        tooltip: 'Tambah Tugas',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}