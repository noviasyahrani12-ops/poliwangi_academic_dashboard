import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({super.key});

  @override
  State<AcademicDashboardScreen> createState() => _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState extends State<AcademicDashboardScreen> {
  final List<Course> _courses = Course.getSampleCourses();
  String _selectedCategory = 'Semua';

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'Semua') {
      return _courses;
    }

    return _courses.where((course) => course.category == _selectedCategory).toList();
  }

  bool _isDarkMode = false;

  int get _totalSks {
    return _courses.fold(0, (total, course) => total + course.sks);
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showCourseDetail(Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text('Kode: ${course.code}'),
              Text('Dosen: ${course.lecturer}'),
              Text('SKS: ${course.sks}'),
              Text('Ruangan: ${course.room}'),
              Text('Kategori: ${course.category}'),

              const SizedBox(height: 16),

              Text(
                'Progress: ${(course.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              LinearProgressIndicator(
                value: course.progress,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tutup'),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard Akademik TRPL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              tooltip: _isDarkMode ? 'Mode Terang' : 'Mode Gelap',
              onPressed: _toggleDarkMode,
            ),
          ],
        ),

        // LayoutBuilder membaca ukuran layar untuk menentukan tata letak responsif
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Breakpoint 600dp: Tablet / Landscape menggunakan 2 kolom
            if (constraints.maxWidth >= 600) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom kiri: banner profil
                    const Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: HeaderBanner(),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Kolom kanan: jumlah kolom mengikuti ruang yang tersedia.
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TAMBAHAN TANTANGAN 3
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total SKS: $_totalSks',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  if (_totalSks > 24) ...[
                                    const SizedBox(height: 8),

                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.red,
                                        ),

                                        SizedBox(width: 8),

                                        Expanded(
                                          child: Text(
                                            'Peringatan: Total SKS melebihi batas maksimal 24 SKS per semester!',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Wrap(
                            spacing: 8.0,
                            children:
                                ['Semua', 'Teori', 'Praktikum'].map((category) {
                              return ChoiceChip(
                                label: Text(category),
                                selected: _selectedCategory == category,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16),

                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                // Lebar kartu tidak melebihi 340 dp. Pada ruang yang
                                // cukup GridView menambah kolom; pada ruang sempit
                                // jumlah kolom otomatis berkurang.
                                maxCrossAxisExtent: 340,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,

                                // Tinggi eksplisit agar seluruh isi CourseCard muat.
                                // Jangan gabungkan dengan childAspectRatio.
                                mainAxisExtent: 240,
                              ),
                              itemCount: _filteredCourses.length,
                              itemBuilder: (context, index) {
                                return CourseCard(
                                  course: _filteredCourses[index],
                                  onTap: () => _showCourseDetail(
                                    _filteredCourses[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Default (smartphone): tata letak 1 kolom vertikal
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const HeaderBanner(),
                const SizedBox(height: 16),

                // TAMBAHAN TANTANGAN 3
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total SKS: $_totalSks',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (_totalSks > 24) ...[
                          const SizedBox(height: 8),

                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                              ),

                              SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  'Peringatan: Total SKS melebihi batas maksimal 24 SKS per semester!',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 8.0,
                  children: ['Semua', 'Teori', 'Praktikum'].map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                Text(
                  'Mata Kuliah Semester 5 (${_filteredCourses.length} Terdaftar)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ..._filteredCourses.map(
                  (course) => CourseCard(
                    course: course,
                    onTap: () => _showCourseDetail(course),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}