# Latihan Mandiri — Kustomisasi Portal KRS

## Identitas

* **Nama:** Novia Syahrani
* **Kelas:** TRPL 2A
* **Modul:** 03 — Navigation & State Management
* **Mata Kuliah:** Pemrograman Perangkat Bergerak

---

## Deskripsi

Latihan mandiri ini merupakan pengembangan Portal KRS menggunakan Flutter. Pada latihan ini diterapkan navigasi menggunakan GoRouter dan pengelolaan state menggunakan Riverpod.

Beberapa fitur yang dikembangkan meliputi konfirmasi penghapusan mata kuliah, validasi duplikasi dan batas maksimal SKS, navigasi detail mata kuliah, serta simulasi error state dan Retry.

---

# Tantangan 1 — Konfirmasi Sebelum Menghapus

Fitur ini digunakan untuk memberikan konfirmasi sebelum mata kuliah dihapus dari daftar KRS.

Ketika tombol hapus ditekan, aplikasi menampilkan dialog konfirmasi. Mata kuliah baru dihapus setelah pengguna menekan tombol **Hapus**.

### Hasil

![Tantangan 1](screenshots/tantangan-1.png)

---

# Tantangan 2 — Validasi Duplikasi dan Batas 24 SKS

Pada tantangan ini diterapkan validasi pada saat menambahkan mata kuliah.

Validasi yang diterapkan:

* Mata kuliah dengan kode yang sama tidak dapat ditambahkan dua kali.
* Total SKS tidak boleh melebihi 24 SKS.
* Jika penambahan berhasil, aplikasi menampilkan notifikasi berhasil.
* Jika penambahan gagal, aplikasi menampilkan pesan kesalahan.

### Hasil

![Tantangan 2](screenshots/tantangan-2.png)

---

# Tantangan 3 — Deep Linking dan Path Parameter

Navigasi detail mata kuliah menggunakan GoRouter dengan path parameter `:code`.

Contoh path:

```text
/modul-03/detail/TRPL501
```

Kode mata kuliah diambil menggunakan `state.pathParameters`.

### Hasil

![Tantangan 3](screenshots/tantangan-3.png)

---

# Tantangan 4 — Error State dan Retry

Pada halaman detail mata kuliah dibuat simulasi beberapa kondisi tampilan, yaitu:

* Loading
* Success
* Error
* Empty

Ketika simulasi error dijalankan, aplikasi menampilkan pesan kesalahan dan tombol **Coba Lagi (Retry)**.

Setelah tombol Retry ditekan, aplikasi menampilkan loading kemudian kembali ke tampilan normal.

### Hasil

![Tantangan 4](screenshots/tantangan-4.png)

---

# Struktur Project

```text
lib/
├── modul_03/
│   ├── models/
│   ├── providers/
│   ├── router/
│   └── screens/
└── main.dart
```

---

# Kesimpulan

Latihan mandiri Kustomisasi Portal KRS telah mengimplementasikan navigasi menggunakan GoRouter dan state management menggunakan Riverpod. Fitur validasi KRS, konfirmasi penghapusan, detail mata kuliah, serta simulasi error dan Retry telah diterapkan pada aplikasi.
