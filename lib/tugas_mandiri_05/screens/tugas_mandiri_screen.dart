import 'package:flutter/material.dart';

import '../services/shared_preferences_service.dart';
import '../widgets/empty_data_widget.dart';
import '../widgets/error_data_widget.dart';

class TugasMandiriScreen extends StatefulWidget {
  const TugasMandiriScreen({super.key});

  @override
  State<TugasMandiriScreen> createState() => _TugasMandiriScreenState();
}

class _TugasMandiriScreenState extends State<TugasMandiriScreen> {
  final SharedPreferencesService _service = SharedPreferencesService();

  List<String> _data = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final result = await _service.getData();

      if (!mounted) return;

      setState(() {
        _data = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  Future<void> _addData() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tambah Data'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama Data',
              hintText: 'Masukkan data',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result != null && result.isNotEmpty) {
      await _service.addData(result);
      await _loadData();
    }
  }

  Future<void> _deleteData(int index) async {
    await _service.deleteData(index);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Mandiri Pertemuan 5'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        tooltip: 'Tambah Data',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isError) {
      return ErrorDataWidget(
        onRetry: _loadData,
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_data.isEmpty) {
      return const EmptyDataWidget();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _data.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(_data[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Hapus Data',
              onPressed: () {
                _deleteData(index);
              },
            ),
          ),
        );
      },
    );
  }
}