# Rekonstruksi Curah Hujan Bulanan NASA POWER

Kode GNU Octave, data, dan referensi untuk Laporan Tahap II Metode Numerik. Penelitian ini membandingkan interpolasi linear, Newton beda terbagi kubik, dan PCHIP untuk mengisi satu bulan curah hujan yang hilang di Grobogan, Cilacap, dan Sragen pada 2011–2025.

Laporan: [docs/A_9_CV_2.pdf](docs/A_9_CV_2.pdf). Kode di `src/` sama dengan BAB III laporan.

## Menjalankan

Butuh GNU Octave 11.3. Dari folder repositori, jalankan:

```
octave-cli src/run_m3c.m
```

Di Octave GUI, pindah ke folder repositori lalu ketik `source('src/run_m3c.m')`. Skrip menghitung 1.584 taksiran (3 kabupaten × 176 bulan × 3 metode) dalam beberapa detik dan menulis hasilnya ke folder `hasil/`. Hasil yang tersimpan di repositori akan tertimpa dengan isi yang sama.

Grafik pada Laporan dibuat dengan `gnuplot hasil/grafik.gp`.

## Hasil

| Berkas | Isi |
| --- | --- |
| `hasil/prediksi.csv` | Taksiran tiga metode untuk 528 bulan target, beserta galat dan kategori |
| `hasil/metrik.csv` | MAE dan kecocokan kategori per kabupaten dan gabungan |
| `hasil/sensitivitas.csv` | MAE sebelum dan sesudah taksiran negatif diganti nol |
| `hasil/mae.png`, `hasil/kategori.png` | Grafik MAE dan kecocokan kategori |

## Isi repositori

| Folder | Isi |
| --- | --- |
| `src/` | Fungsi interpolasi dan skrip eksperimen `run_m3c.m` |
| `data/` | CSV curah hujan bulanan dan respons asli NASA POWER |
| `hasil/` | Hasil eksperimen dan skrip grafik |
| `references/` | Jurnal dan arsip sumber yang dikutip |
| `materials/` | Slide kuliah interpolasi |
| `docs/` | Laporan Tahap II (Word dan PDF) |
