import 'package:flutter/material.dart';

import '../models/announcement.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              announcement.category,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                const Icon(Icons.person_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(announcement.author),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const Icon(Icons.calendar_today_outlined, size: 20),
                const SizedBox(width: 8),
                Text(announcement.date),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              announcement.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                const Icon(Icons.visibility_outlined, size: 20),
                const SizedBox(width: 8),
                Text('${announcement.readCount} kali dibaca'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}