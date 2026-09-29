import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _dataKey = 'tugas_mandiri_data';

  // Mengambil semua data
  Future<List<String>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_dataKey) ?? [];
  }

  // Menambahkan data
  Future<void> addData(String data) async {
    final prefs = await SharedPreferences.getInstance();

    final currentData = prefs.getStringList(_dataKey) ?? [];

    currentData.add(data);

    await prefs.setStringList(_dataKey, currentData);
  }

  // Menghapus data
  Future<void> deleteData(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final currentData = prefs.getStringList(_dataKey) ?? [];

    if (index >= 0 && index < currentData.length) {
      currentData.removeAt(index);
      await prefs.setStringList(_dataKey, currentData);
    }
  }

  // Menghapus semua data
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dataKey);
  }
}