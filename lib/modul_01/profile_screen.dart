import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Foto profil
            const CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.person,
                size: 70,
              ),
            ),

            const SizedBox(height: 20),

            // Nama mahasiswa
            const Text(
              'Novia Syahrani',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Program studi
            const Text(
              'Teknologi Rekayasa Perangkat Lunak',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            // Kampus
            const Text(
              'Politeknik Negeri Banyuwangi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            // Informasi mahasiswa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('NIM'),
                      subtitle: Text('362558302144'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Program Studi'),
                      subtitle: Text('Teknologi Rekayasa Perangkat Lunak'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Semester'),
                      subtitle: Text('2'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.verified_user),
                      title: Text('Status'),
                      subtitle: Text('Mahasiswa Aktif TRPL — Angkatan 2024'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol status
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Status: Mahasiswa Aktif TRPL — Angkatan 2024',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Lihat Status Mahasiswa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}