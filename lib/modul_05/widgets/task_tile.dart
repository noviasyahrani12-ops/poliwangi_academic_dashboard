import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
  });

  final Task task;
  final ValueChanged<Task> onToggle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna =
        Theme.of(context).colorScheme;

    // Membaca tanggal langsung dari createdAt.
    final DateTime? tanggal =
        DateTime.tryParse(task.createdAt);

    final String tanggalText = tanggal == null
        ? 'Tanggal tidak valid'
        : '${tanggal.day}/${tanggal.month}/${tanggal.year}';

    String prioritasText;

    switch (task.prioritas) {
      case 1:
        prioritasText = 'Tinggi';
        break;
      case 3:
        prioritasText = 'Rendah';
        break;
      default:
        prioritasText = 'Sedang';
    }

    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: CheckboxListTile(
        value: task.done,
        onChanged: (_) {
          onToggle(task);
        },
        controlAffinity:
            ListTileControlAffinity.leading,
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.done
                ? TextDecoration.lineThrough
                : null,
            fontWeight: FontWeight.w600,
            color: task.done
                ? Colors.grey.shade600
                : warna.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 6,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                task.course,
              ),
              const SizedBox(height: 4),
              Text(
                'Dibuat: $tanggalText',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Prioritas: $prioritasText',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}