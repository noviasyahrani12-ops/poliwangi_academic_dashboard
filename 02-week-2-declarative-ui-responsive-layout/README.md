# Laporan Praktikum Modul 02: Declarative UI & Responsive Layout

- **Nama**: Novia Syahrani
- **NIM**: 362558302144
- **Kelas / Prodi**: 2A / Sarjana Terapan TRPL
- **Mata Kuliah**: Pemrograman Perangkat Bergerak

---

## 1. Ringkasan Implementasi

Pada praktikum Modul 02 ini, saya membuat Dashboard Akademik TRPL menggunakan Flutter dengan konsep Declarative UI dan Responsive Layout.

Implementasi yang dilakukan meliputi:

- Membuat tampilan Dashboard Akademik TRPL.
- Menggunakan `LayoutBuilder` untuk membuat tampilan responsif.
- Menggunakan `ListView` pada ukuran layar kecil.
- Menggunakan `GridView` pada ukuran layar lebar.
- Membuat filter mata kuliah menggunakan `Wrap` dan `ChoiceChip`.
- Menambahkan fitur detail mata kuliah menggunakan `Modal BottomSheet`.
- Menambahkan perhitungan Total SKS menggunakan `fold`.
- Menambahkan peringatan jika Total SKS melebihi 24 SKS.
- Menggunakan `Stack` dan `Positioned` pada tampilan kartu mata kuliah.
- Menambahkan fitur Dark Mode dan Light Mode.
- Menggunakan Material 3 pada tampilan aplikasi.

---

## 2. Fitur yang Diimplementasikan

### Tantangan 1 — Filter Kategori

Filter kategori dibuat menggunakan `Wrap` dan `ChoiceChip`.

Kategori yang tersedia:

- Semua
- Teori
- Praktikum

Pengguna dapat memilih kategori untuk menampilkan mata kuliah sesuai kategori yang dipilih.

### Tantangan 2 — Modal BottomSheet

Setiap kartu mata kuliah dapat diklik untuk menampilkan detail mata kuliah menggunakan `showModalBottomSheet`.

Informasi yang ditampilkan meliputi:

- Nama mata kuliah
- Kode mata kuliah
- Dosen
- SKS
- Ruangan
- Kategori
- Progress

### Tantangan 3 — Total SKS dan Warning

Total SKS dihitung menggunakan fungsi `fold`.

Total SKS pada data yang digunakan adalah:

**12 SKS**

Sistem juga memiliki peringatan apabila total SKS melebihi batas maksimal 24 SKS dalam satu semester.

### Tantangan 4 — Responsive Layout dan Dark Mode

Responsive layout dibuat menggunakan `LayoutBuilder` dengan breakpoint 600 dp.

- Lebar layar kurang dari 600 dp menggunakan tampilan satu kolom.
- Lebar layar 600 dp atau lebih menggunakan tampilan GridView.
- Dark Mode dapat diaktifkan menggunakan tombol pada AppBar.

---

## 3. Bukti Tangkapan Layar

### Portrait — Light Mode

![Portrait Light](.screenshots/Screenshot (906).png)

### Portrait — Dark Mode

![Portrait Dark](./screenshots/running_portrait_dark.png)

### Tablet / Wide — 2 Kolom

![Tablet Wide](./screenshots/running_tablet_wide.png)

---

## 4. Kendala yang Dihadapi dan Solusi

### Kendala

Kendala yang dihadapi adalah membuat tampilan dashboard dapat menyesuaikan ukuran layar yang berbeda. Selain itu, diperlukan pengaturan agar kartu mata kuliah tetap tersusun dengan baik pada layar kecil maupun layar lebar.

### Solusi

Solusinya adalah menggunakan `LayoutBuilder` untuk membaca ukuran layar. Jika lebar layar kurang dari 600 dp digunakan `ListView`, sedangkan jika lebar layar 600 dp atau lebih digunakan `GridView`.

Selain itu, penggunaan `Expanded`, `Row`, `Column`, dan `Wrap` membantu mengatur posisi widget agar tampilan tetap rapi dan responsif.

---

## 5. Hasil Analisis

Berdasarkan hasil implementasi, penggunaan Declarative UI pada Flutter mempermudah pembuatan tampilan karena UI dibangun berdasarkan kondisi dan state aplikasi.

Penggunaan `LayoutBuilder` membuat aplikasi dapat menyesuaikan tampilan berdasarkan ukuran layar. Fitur filter kategori membuat pengguna lebih mudah memilih mata kuliah, sedangkan Modal BottomSheet dapat digunakan untuk menampilkan informasi detail tanpa berpindah halaman.

Fitur Dark Mode juga membuat tampilan aplikasi dapat digunakan dalam kondisi terang maupun gelap.

---

## 6. Kesimpulan

Praktikum Modul 02 berhasil mengimplementasikan konsep Declarative UI dan Responsive Layout pada Flutter melalui pembuatan Dashboard Akademik TRPL.

Fitur filter kategori, detail mata kuliah, perhitungan Total SKS, peringatan batas SKS, responsive layout, dan Dark Mode telah berhasil diterapkan dan dapat dijalankan pada aplikasi.