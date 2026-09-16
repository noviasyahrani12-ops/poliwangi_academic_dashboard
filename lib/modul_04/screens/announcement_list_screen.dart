import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement.dart';
import '../providers/announcement_provider.dart';
import 'announcement_detail_screen.dart';

class AnnouncementListScreen extends ConsumerWidget {
  const AnnouncementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAnnouncements = ref.watch(announcementsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ['Semua', 'Akademik', 'Beasiswa', 'Kegiatan', 'Prestasi'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Portal Pengumuman TRPL'),
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan',
            onPressed: () => ref.invalidate(announcementsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Baris ChoiceChip Filter Kategori
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedCategoryProvider.notifier).select(cat);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          // Area Konten 4-State
          Expanded(
            child: asyncAnnouncements.when(
              // 1. Loading State
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF0284C7)),
              ),

              // 2. Error State
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      const Text(
                        'Gagal Memuat Data',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString().replaceAll('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(announcementsProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),

              // 3 & 4. Success / Empty State
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text('Tidak ada pengumuman untuk kategori "$selectedCategory"'),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFF0284C7),
                 onRefresh: () => ref.refresh(announcementsProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.category} • ${item.date}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AnnouncementDetailScreen(announcement: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}