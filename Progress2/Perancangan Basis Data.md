# Perancangan Basis Data
Studi Kasus:Sistem Pengelolaan Penelitian dan Pengabdian Dosen  
Mata Kuliah: Sistem Basis Data  
Project Based Learning (PjBL) — Progres 2

Kelompok 11
Muhammad Ridho Faizal (2301020124)
Ragil Novant (2301020098)
Akbar Rahmat Arifin (2301020055)

## 1. ERD (Entity Relationship Diagram)

ERD berikut menggambarkan seluruh entitas, atribut, dan relasi antar entitas pada Sistem Pengelolaan Penelitian dan Pengabdian Dosen.

## 2. Penjelasan Entitas dan Relasi

### 2.1 Penjelasan Entitas

| No | Entitas | Deskripsi |
|---|---|---|
| 1 | DOSEN | Menyimpan data dosen yang bertindak sebagai pengusul proposal penelitian/pengabdian. |
| 2 | SKEMA | Menyimpan data skema/periode pengajuan yang dibuka oleh LPPM, misalnya skema penelitian internal atau pengabdian masyarakat. |
| 3 | PROPOSAL | Entitas inti yang menyimpan data usulan penelitian/pengabdian yang diajukan dosen. |
| 4 | ANGGOTA_PROPOSAL | Tabel relasi banyak-ke-banyak antara DOSEN dan PROPOSAL, karena satu proposal bisa melibatkan lebih dari satu dosen, dan satu dosen bisa mengajukan lebih dari satu proposal. |
| 5 | RAB | Menyimpan rincian anggaran biaya per butir yang berelasi dengan proposal tertentu. |
| 6 | REVIEWER | Menyimpan data reviewer yang bertugas menilai proposal. |
| 7 | REVIEW | Tabel relasi antara PROPOSAL dan REVIEWER, menyimpan data hasil penilaian (skor, catatan, rekomendasi). |
| 8 | RIWAYAT_STATUS | Menyimpan histori perubahan status proposal agar setiap transisi status dapat dilacak. |
| 9 | KONTRAK | Menyimpan data kontrak yang diterbitkan ketika proposal disetujui. Berelasi satu-ke-satu dengan PROPOSAL. |
| 10 | TERMIN_PENCAIRAN | Menyimpan jadwal dan realisasi pencairan dana per termin, berelasi banyak ke satu KONTRAK. |
| 11 | LAPORAN | Menyimpan data laporan kemajuan dan laporan akhir yang diunggah dosen. |
| 12 | LUARAN | Menyimpan data output/luaran penelitian (publikasi, HKI, prototipe) yang dihasilkan dari proposal. |

### 2.2 Penjelasan Relasi

| No | Relasi | Kardinalitas | Keterangan |
|---|---|---|---|
| 1 | DOSEN — ANGGOTA_PROPOSAL | 1 ke banyak | Satu dosen dapat terdaftar di banyak proposal (sebagai ketua atau anggota). |
| 2 | PROPOSAL — ANGGOTA_PROPOSAL | 1 ke banyak | Satu proposal melibatkan minimal satu dosen (ketua) dan dapat memiliki beberapa anggota. |
| 3 | SKEMA — PROPOSAL | 1 ke banyak | Satu skema dapat menaungi banyak proposal, tetapi setiap proposal hanya berada di satu skema. |
| 4 | PROPOSAL — RAB | 1 ke banyak | Satu proposal dapat memiliki banyak butir RAB (rincian anggaran biaya). |
| 5 | PROPOSAL — REVIEW | 1 ke banyak | Satu proposal dapat direview oleh lebih dari satu reviewer, menghasilkan banyak data review. |
| 6 | REVIEWER — REVIEW | 1 ke banyak | Satu reviewer dapat menilai banyak proposal, setiap penilaian disimpan sebagai satu record REVIEW. |
| 7 | PROPOSAL — RIWAYAT_STATUS | 1 ke banyak | Setiap perubahan status proposal (misalnya dari "diajukan" ke "direview") dicatat sebagai satu baris riwayat. |
| 8 | PROPOSAL — KONTRAK | 1 ke satu (opsional) | Hanya proposal yang berstatus "diterima" yang menghasilkan satu kontrak. |
| 9 | KONTRAK — TERMIN_PENCAIRAN | 1 ke banyak | Satu kontrak memiliki beberapa termin pencairan dana (biasanya termin 1 dan termin 2). |
| 10 | PROPOSAL — LAPORAN | 1 ke banyak | Satu proposal dapat memiliki lebih dari satu laporan (laporan kemajuan dan laporan akhir). |
| 11 | PROPOSAL — LUARAN | 1 ke banyak | Satu proposal dapat menghasilkan lebih dari satu luaran (misalnya satu publikasi dan satu HKI). |

---

## 3. Kamus Data (Data Dictionary)

### 3.1 Tabel DOSEN

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| nidn | VARCHAR | 20 | PK, NOT NULL | Nomor Induk Dosen Nasional (unik per dosen) |
| nama | VARCHAR | 100 | NOT NULL | Nama lengkap dosen |
| program_studi | VARCHAR | 100 | NOT NULL | Program studi tempat dosen bertugas |
| fakultas | VARCHAR | 100 | NOT NULL | Fakultas tempat dosen bertugas |
| email | VARCHAR | 100 | NOT NULL, UNIQUE | Email resmi dosen |
| no_hp | VARCHAR | 20 | NULL | Nomor handphone dosen |

### 3.2 Tabel SKEMA

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_skema | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik skema |
| nama_skema | VARCHAR | 100 | NOT NULL | Nama skema (contoh: Penelitian Internal, Pengabdian Masyarakat) |
| jenis | ENUM | — | NOT NULL | Nilai: 'penelitian' atau 'pengabdian' |
| tahun_anggaran | INT | 4 | NOT NULL | Tahun anggaran skema berlaku |
| kuota_dana | DECIMAL | 15,2 | NOT NULL | Total kuota dana yang tersedia pada skema |
| tanggal_buka | DATE | — | NOT NULL | Tanggal dibukanya periode pengajuan |
| tanggal_tutup | DATE | — | NOT NULL | Tanggal ditutupnya periode pengajuan |

### 3.3 Tabel PROPOSAL

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_proposal | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik proposal |
| id_skema | INT | — | FK → SKEMA(id_skema), NOT NULL | Skema yang diikuti |
| judul | VARCHAR | 255 | NOT NULL | Judul proposal penelitian/pengabdian |
| ringkasan | TEXT | — | NULL | Ringkasan isi proposal |
| status | ENUM | — | NOT NULL | Nilai: 'diajukan', 'direview', 'revisi', 'diterima', 'ditolak' |
| tanggal_ajuan | DATE | — | NOT NULL | Tanggal proposal diajukan |

### 3.4 Tabel ANGGOTA_PROPOSAL

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_anggota | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik record anggota |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL | Proposal yang diikuti |
| nidn | VARCHAR | 20 | FK → DOSEN(nidn), NOT NULL | NIDN dosen yang terlibat |
| peran | ENUM | — | NOT NULL | Nilai: 'ketua' atau 'anggota' |

### 3.5 Tabel RAB

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_rab | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik butir RAB |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL | Proposal yang memiliki RAB ini |
| uraian_biaya | VARCHAR | 255 | NOT NULL | Deskripsi butir biaya (contoh: honorarium, transport) |
| jumlah_biaya | DECIMAL | 15,2 | NOT NULL | Jumlah biaya dalam rupiah |

### 3.6 Tabel REVIEWER

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_reviewer | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik reviewer |
| nama | VARCHAR | 100 | NOT NULL | Nama lengkap reviewer |
| bidang_keahlian | VARCHAR | 100 | NOT NULL | Bidang keahlian reviewer |
| email | VARCHAR | 100 | NOT NULL, UNIQUE | Email reviewer |

### 3.7 Tabel REVIEW

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_review | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik data review |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL | Proposal yang dinilai |
| id_reviewer | INT | — | FK → REVIEWER(id_reviewer), NOT NULL | Reviewer yang menilai |
| skor | INT | — | NOT NULL | Skor penilaian (rentang 0–100) |
| catatan | TEXT | — | NULL | Catatan atau masukan dari reviewer |
| rekomendasi | ENUM | — | NOT NULL | Nilai: 'diterima', 'revisi', 'ditolak' |
| tanggal_review | DATE | — | NOT NULL | Tanggal review dilakukan |

### 3.8 Tabel RIWAYAT_STATUS

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_riwayat | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik riwayat |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL | Proposal yang statusnya berubah |
| status | ENUM | — | NOT NULL | Nilai: 'diajukan', 'direview', 'revisi', 'diterima', 'ditolak' |
| tanggal_ubah | DATE | — | NOT NULL | Tanggal perubahan status |
| keterangan | TEXT | — | NULL | Keterangan tambahan perubahan status |

### 3.9 Tabel KONTRAK

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_kontrak | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik kontrak |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL, UNIQUE | Proposal yang dikontrakkan (1 ke 1) |
| no_kontrak | VARCHAR | 50 | NOT NULL, UNIQUE | Nomor kontrak resmi |
| nominal_dana | DECIMAL | 15,2 | NOT NULL | Total dana yang dikontrakkan |
| tanggal_ttd | DATE | — | NOT NULL | Tanggal penandatanganan kontrak |

### 3.10 Tabel TERMIN_PENCAIRAN

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_termin | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik termin |
| id_kontrak | INT | — | FK → KONTRAK(id_kontrak), NOT NULL | Kontrak yang termin ini termasuk di dalamnya |
| nomor_termin | INT | — | NOT NULL | Urutan termin (1, 2, dst) |
| jumlah_dana | DECIMAL | 15,2 | NOT NULL | Jumlah dana yang dicairkan pada termin ini |
| tanggal_cair | DATE | — | NULL | Tanggal realisasi pencairan |
| status_cair | ENUM | — | NOT NULL | Nilai: 'belum_cair' atau 'sudah_cair' |

### 3.11 Tabel LAPORAN

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_laporan | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik laporan |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL | Proposal yang laporan ini milik |
| jenis_laporan | ENUM | — | NOT NULL | Nilai: 'kemajuan' atau 'akhir' |
| file_laporan | VARCHAR | 255 | NOT NULL | Path atau nama file laporan |
| tanggal_unggah | DATE | — | NOT NULL | Tanggal laporan diunggah |
| status_verifikasi | ENUM | — | NOT NULL | Nilai: 'menunggu', 'diverifikasi', 'ditolak' |

### 3.12 Tabel LUARAN

| Nama Field | Tipe Data | Panjang | Constraint | Keterangan |
|---|---|---|---|---|
| id_luaran | INT | — | PK, AUTO_INCREMENT, NOT NULL | ID unik luaran |
| id_proposal | INT | — | FK → PROPOSAL(id_proposal), NOT NULL | Proposal yang menghasilkan luaran ini |
| jenis_luaran | ENUM | — | NOT NULL | Nilai: 'publikasi_jurnal', 'HKI', 'prototipe', 'buku', 'lainnya' |
| judul_luaran | VARCHAR | 255 | NOT NULL | Judul atau nama luaran |
| bukti_dokumen | VARCHAR | 255 | NULL | Path file atau link bukti luaran |

---

## 4. Normalisasi Data

Proses normalisasi dilakukan berdasarkan contoh data pengajuan proposal yang melibatkan dosen, RAB, reviewer, dan kontrak.

### 4.1 UNF (Unnormalized Form)

Tabel awal sebelum normalisasi — data masih bercampur dalam satu tabel besar dengan nilai berulang dan grup berulang.

| id_proposal | judul | nama_skema | tahun | nidn_ketua | nama_ketua | prodi_ketua | nidn_anggota | nama_anggota | uraian_rab1 | biaya_rab1 | uraian_rab2 | biaya_rab2 | nama_reviewer | skor | rekomendasi | no_kontrak | nominal_dana | status_cair |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Analisis Kualitas Air Sungai | Penelitian Internal | 2025 | 0101001 | Budi Santoso | Teknik Lingkungan | 0101002 | Rina Dewi | Honorarium | 2.000.000 | Transport | 500.000 | Ahmad Fauzi | 85 | diterima | K/001/2025 | 15.000.000 | sudah_cair |
| 2 | Pelatihan UMKM Pesisir | Pengabdian Masyarakat | 2025 | 0101003 | Sari Indah | Manajemen | — | — | ATK | 300.000 | Konsumsi | 700.000 | Budi Hartono | 78 | diterima | K/002/2025 | 10.000.000 | belum_cair |

Masalah UNF:
- Terdapat grup berulang (uraian_rab1, biaya_rab1, uraian_rab2, biaya_rab2) dalam satu baris.
- Data dosen (nidn, nama, prodi) berulang di setiap baris proposal.
- Data reviewer dan kontrak ikut bergabung dalam satu tabel yang sama.

---

### 4.2 1NF (First Normal Form)

**Syarat 1NF:** Setiap kolom hanya memiliki satu nilai (atomik), tidak ada grup berulang, dan setiap baris dapat diidentifikasi secara unik.

**Perubahan yang dilakukan:**
- Memecah grup berulang RAB (rab1, rab2) menjadi baris terpisah dengan PK komposit (id_proposal, id_rab).
- Menambahkan kolom id_anggota untuk mengatasi data anggota yang berulang.

**Tabel setelah 1NF:**

**Proposal_1NF**

| id_proposal | judul | nama_skema | tahun | nidn_ketua | nama_ketua | prodi_ketua | nidn_anggota | nama_anggota | id_rab | uraian_biaya | jumlah_biaya | id_reviewer | nama_reviewer | skor | rekomendasi | no_kontrak | nominal_dana | status_cair |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Analisis Kualitas Air Sungai | Penelitian Internal | 2025 | 0101001 | Budi Santoso | Teknik Lingkungan | 0101002 | Rina Dewi | 1 | Honorarium | 2.000.000 | 1 | Ahmad Fauzi | 85 | diterima | K/001/2025 | 15.000.000 | sudah_cair |
| 1 | Analisis Kualitas Air Sungai | Penelitian Internal | 2025 | 0101001 | Budi Santoso | Teknik Lingkungan | 0101002 | Rina Dewi | 2 | Transport | 500.000 | 1 | Ahmad Fauzi | 85 | diterima | K/001/2025 | 15.000.000 | sudah_cair |
| 2 | Pelatihan UMKM Pesisir | Pengabdian Masyarakat | 2025 | 0101003 | Sari Indah | Manajemen | — | — | 3 | ATK | 300.000 | 2 | Budi Hartono | 78 | diterima | K/002/2025 | 10.000.000 | belum_cair |
| 2 | Pelatihan UMKM Pesisir | Pengabdian Masyarakat | 2025 | 0101003 | Sari Indah | Manajemen | — | — | 4 | Konsumsi | 700.000 | 2 | Budi Hartono | 78 | diterima | K/002/2025 | 10.000.000 | belum_cair |

Masalah yang masih ada di 1NF:
- Masih terdapat dependensi parsial: nama_ketua dan prodi_ketua bergantung pada nidn_ketua, bukan pada id_proposal.
- nama_reviewer bergantung pada id_reviewer, bukan pada kombinasi id_proposal + id_reviewer.
- Data proposal (judul, nama_skema, tahun) masih berulang di setiap baris RAB.

### 4.3 2NF (Second Normal Form)

Syarat 2NF: Sudah memenuhi 1NF, dan setiap atribut non-key harus bergantung penuh pada primary key (tidak boleh ada dependensi parsial).

Perubahan yang dilakukan:
- Memisahkan data DOSEN ke tabel tersendiri karena nama_ketua dan prodi_ketua bergantung pada nidn, bukan pada id_proposal.
- Memisahkan data REVIEWER ke tabel tersendiri.
- Memisahkan data PROPOSAL ke tabel tersendiri.
- Memisahkan data RAB ke tabel tersendiri dengan FK ke PROPOSAL.

Tabel setelah 2NF:

**DOSEN**

| nidn | nama | program_studi |
|---|---|---|
| 0101001 | Budi Santoso | Teknik Lingkungan |
| 0101002 | Rina Dewi | Teknik Lingkungan |
| 0101003 | Sari Indah | Manajemen |

**PROPOSAL**

| id_proposal | judul | id_skema | tanggal_ajuan | status |
|---|---|---|---|---|
| 1 | Analisis Kualitas Air Sungai | 1 | 2025-01-10 | diterima |
| 2 | Pelatihan UMKM Pesisir | 2 | 2025-01-12 | diterima |

**RAB**

| id_rab | id_proposal | uraian_biaya | jumlah_biaya |
|---|---|---|---|
| 1 | 1 | Honorarium | 2.000.000 |
| 2 | 1 | Transport | 500.000 |
| 3 | 2 | ATK | 300.000 |
| 4 | 2 | Konsumsi | 700.000 |

**REVIEWER**

| id_reviewer | nama | bidang_keahlian |
|---|---|---|
| 1 | Ahmad Fauzi | Teknik Lingkungan |
| 2 | Budi Hartono | Manajemen |

**REVIEW**

| id_review | id_proposal | id_reviewer | skor | rekomendasi |
|---|---|---|---|---|
| 1 | 1 | 1 | 85 | diterima |
| 2 | 2 | 2 | 78 | diterima |

**Masalah yang masih ada di 2NF:**
- Pada tabel PROPOSAL, atribut nama_skema dan tahun masih bergantung pada id_skema (dependensi transitif), bukan langsung pada id_proposal.
- Pada tabel KONTRAK (jika digabung), status_cair bergantung pada id_termin, bukan langsung pada id_kontrak.

---

### 4.4 3NF (Third Normal Form)

**Syarat 3NF:** Sudah memenuhi 2NF, dan tidak ada dependensi transitif (atribut non-key tidak boleh bergantung pada atribut non-key lainnya).

**Perubahan yang dilakukan:**
- Memisahkan SKEMA ke tabel tersendiri, karena nama_skema dan tahun bergantung pada id_skema, bukan pada id_proposal.
- Memisahkan KONTRAK dan TERMIN_PENCAIRAN menjadi dua tabel terpisah.
- Memisahkan ANGGOTA_PROPOSAL sebagai tabel relasi untuk menghilangkan ketergantungan ganda antara dosen dan proposal.

**Tabel final setelah 3NF:**

**SKEMA**

| id_skema | nama_skema | jenis | tahun_anggaran | kuota_dana |
|---|---|---|---|---|
| 1 | Penelitian Internal | penelitian | 2025 | 500.000.000 |
| 2 | Pengabdian Masyarakat | pengabdian | 2025 | 300.000.000 |

**PROPOSAL** *(revisi — id_skema sebagai FK, tidak lagi menyimpan nama_skema)*

| id_proposal | id_skema | judul | status | tanggal_ajuan |
|---|---|---|---|---|
| 1 | 1 | Analisis Kualitas Air Sungai | diterima | 2025-01-10 |
| 2 | 2 | Pelatihan UMKM Pesisir | diterima | 2025-01-12 |

**ANGGOTA_PROPOSAL**

| id_anggota | id_proposal | nidn | peran |
|---|---|---|---|
| 1 | 1 | 0101001 | ketua |
| 2 | 1 | 0101002 | anggota |
| 3 | 2 | 0101003 | ketua |

**KONTRAK**

| id_kontrak | id_proposal | no_kontrak | nominal_dana | tanggal_ttd |
|---|---|---|---|---|
| 1 | 1 | K/001/2025 | 15.000.000 | 2025-02-01 |
| 2 | 2 | K/002/2025 | 10.000.000 | 2025-02-03 |

**TERMIN_PENCAIRAN** *(status_cair bergantung pada id_termin, bukan id_kontrak — sudah terpisah)*

| id_termin | id_kontrak | nomor_termin | jumlah_dana | status_cair |
|---|---|---|---|---|
| 1 | 1 | 1 | 9.000.000 | sudah_cair |
| 2 | 1 | 2 | 6.000.000 | belum_cair |
| 3 | 2 | 1 | 7.000.000 | belum_cair |

**Ringkasan tabel final setelah 3NF:**

| No | Nama Tabel | Jumlah Field | Keterangan |
|---|---|---|---|
| 1 | DOSEN | 6 | Entitas mandiri |
| 2 | SKEMA | 7 | Entitas mandiri |
| 3 | PROPOSAL | 5 | FK ke SKEMA |
| 4 | ANGGOTA_PROPOSAL | 4 | Tabel relasi DOSEN–PROPOSAL |
| 5 | RAB | 4 | FK ke PROPOSAL |
| 6 | REVIEWER | 4 | Entitas mandiri |
| 7 | REVIEW | 7 | Tabel relasi PROPOSAL–REVIEWER |
| 8 | RIWAYAT_STATUS | 5 | FK ke PROPOSAL |
| 9 | KONTRAK | 5 | FK ke PROPOSAL (1–1) |
| 10 | TERMIN_PENCAIRAN | 6 | FK ke KONTRAK |
| 11 | LAPORAN | 6 | FK ke PROPOSAL |
| 12 | LUARAN | 5 | FK ke PROPOSAL |

---

## 5. Revisi Analisis Kebutuhan

Berdasarkan proses perancangan basis data pada Progres 2, terdapat beberapa revisi minor terhadap dokumen analisis kebutuhan yang dibuat pada Progres 1:

| No | Poin yang Direvisi | Kondisi Progres 1 | Revisi Progres 2 |
|---|---|---|---|
| 1 | Entitas ANGGOTA_PROPOSAL | Disebutkan sebagai tabel relasi tanpa PK tersendiri | Ditambahkan field id_anggota sebagai PK mandiri (AUTO_INCREMENT) untuk mempermudah operasi UPDATE dan DELETE pada record tertentu. |
| 2 | Tipe data field status (PROPOSAL, LAPORAN, TERMIN_PENCAIRAN) | Ditulis sebagai "string" | Dipertegas menjadi tipe data ENUM dengan nilai yang sudah ditentukan untuk menjaga integritas data. |
| 3 | Field id_proposal pada KONTRAK | Tidak disebutkan constraint UNIQUE | Ditambahkan constraint UNIQUE pada id_proposal di tabel KONTRAK untuk memastikan relasi benar-benar 1 ke 1. |
| 4 | Kebutuhan fungsional no. 11 (pencarian/filter) | Dirumuskan secara umum | Dipertegas: filter data proposal berbasis indeks pada field id_skema, status, dan tanggal_ajuan untuk mendukung query efisien. |