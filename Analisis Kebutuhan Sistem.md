Analisis Kebutuhan Sistem

Studi Kasus: Sistem Pengelolaan Penelitian dan Pengabdian Dosen
Mata Kuliah: Sistem Basis Data
Project Based Learning (PjBL) — Progres 1

Kelompok:

NamaNIM
Muhammad Ridho Faizal2301020124
Ragil Novant2301020098
Akbar Rahmat Arifin2301020055


1. Deskripsi Studi Kasus

Perguruan tinggi memiliki kewajiban menjalankan Tri Dharma Perguruan Tinggi, salah satunya adalah penelitian dan pengabdian kepada masyarakat yang dilakukan oleh dosen. Selama ini, data terkait pengajuan proposal, hasil review, kontrak, jadwal pencairan dana, hingga laporan akhir penelitian/pengabdian tersimpan secara tersebar dalam dokumen fisik, spreadsheet, maupun file individu milik masing-masing dosen atau staf LPPM (Lembaga Penelitian dan Pengabdian kepada Masyarakat).

Karena data tidak tersimpan dalam satu basis data yang terstruktur, muncul berbagai masalah seperti duplikasi data, kesulitan menarik rekapitulasi data penelitian per tahun/per dosen, serta sulitnya menjaga konsistensi data ketika ada perubahan status proposal atau pencairan dana. Oleh karena itu, dibutuhkan perancangan basis data yang baik agar seluruh data penelitian dan pengabdian dosen dapat disimpan, dikelola, dan ditarik kembali secara efisien, konsisten, dan terhindar dari redundansi.

2. Latar Belakang dan Tujuan Sistem

2.1 Latar Belakang

Pengelolaan data penelitian dan pengabdian dosen yang belum terstruktur menyebabkan data sulit diintegrasikan antarproses, misalnya antara data proposal dengan data reviewer, atau antara data kontrak dengan data pencairan dana. Tanpa perancangan basis data yang tepat (entitas, atribut, relasi, dan normalisasi yang jelas), risiko terjadinya redundansi data dan anomali (insert, update, delete) akan tinggi.

2.2 Tujuan

Perancangan basis data ini bertujuan untuk:


Mengidentifikasi entitas-entitas utama yang terlibat dalam proses penelitian dan pengabdian dosen.
Menentukan atribut dan relasi antarentitas secara tepat agar data konsisten dan tidak redundan.
Menyediakan struktur data yang mendukung kebutuhan pencarian, pelaporan, dan rekapitulasi data penelitian/pengabdian.
Menjadi dasar dalam pembuatan ERD dan skema basis data relasional pada tahap berikutnya.


3. Identifikasi Aktor

Aktor diidentifikasi berdasarkan siapa saja yang menjadi sumber atau pengguna data dalam sistem.

AktorPeran terhadap DataDosen (Pengusul)Sumber data proposal, anggota tim, laporan kemajuan/akhir, dan luaran (output) penelitian/pengabdian.ReviewerSumber data hasil penilaian/review terhadap proposal.Admin LPPMMengelola data master (skema, periode), memverifikasi dan mengubah status data proposal, mengelola data kontrak dan pencairan dana.Pimpinan/Ketua LPPMPengguna data rekapitulasi (hanya membaca/mengambil data agregat untuk laporan).

4. Kebutuhan Fungsional

Kebutuhan fungsional berikut difokuskan pada operasi data (CRUD dan pengambilan data) yang harus didukung oleh basis data:


1.Sistem harus dapat menyimpan dan mengelola data pengguna beserta perannya (dosen, reviewer, admin, pimpinan).
2.Sistem harus dapat menyimpan data skema/periode penelitian dan pengabdian (nama skema, tahun, kuota dana, tanggal buka-tutup).
3.Sistem harus dapat menyimpan data proposal yang diajukan dosen, termasuk relasi proposal dengan anggota tim (karena satu proposal bisa memiliki lebih dari satu dosen).
4.Sistem harus dapat menyimpan data Rencana Anggaran Biaya (RAB) yang berelasi dengan proposal tertentu.
5.Sistem harus dapat menyimpan data hasil review, dengan relasi banyak-ke-banyak antara proposal dan reviewer (satu proposal bisa direview lebih dari satu reviewer, satu reviewer bisa menilai banyak proposal).
6.Sistem harus dapat menyimpan data status proposal beserta riwayat perubahannya (log status) agar histori dapat dilacak.
7.Sistem harus dapat menyimpan data kontrak yang berelasi satu-ke-satu dengan proposal yang diterima.
8.Sistem harus dapat menyimpan data termin pencairan dana yang berelasi satu-ke-banyak dengan data kontrak.
9.Sistem harus dapat menyimpan data laporan kemajuan dan laporan akhir yang berelasi dengan proposal.
10.Sistem harus dapat menyimpan data luaran/output penelitian (publikasi, HKI, prototipe) yang berelasi dengan proposal.
11.Sistem harus dapat melakukan pencarian dan filter data proposal berdasarkan tahun, status, skema, atau dosen pengusul.
12.Sistem harus dapat menghasilkan data rekapitulasi (agregat) jumlah proposal, dana, dan luaran per tahun/per fakultas/per dosen.


5. Kebutuhan Data

Berikut calon entitas data yang menjadi dasar perancangan ERD pada Progres 2:


Dosen: NIDN, nama, program studi/fakultas, email, no. HP.
Reviewer: id reviewer, nama, bidang keahlian, email.
Skema: id skema, nama skema, jenis (penelitian/pengabdian), tahun anggaran, kuota dana, tanggal buka, tanggal tutup.
Proposal: id proposal, judul, ringkasan, id skema (FK), tanggal pengajuan, status terkini.
Anggota_Proposal (tabel relasi): id proposal (FK), NIDN dosen (FK), peran dalam tim (ketua/anggota).
RAB: id RAB, id proposal (FK), uraian biaya, jumlah biaya.
Review: id review, id proposal (FK), id reviewer (FK), skor, catatan, rekomendasi, tanggal review.
Riwayat_Status: id riwayat, id proposal (FK), status, tanggal perubahan, keterangan.
Kontrak: id kontrak, id proposal (FK), nomor kontrak, nominal dana, tanggal tanda tangan.
Termin_Pencairan: id termin, id kontrak (FK), nomor termin, jumlah dana, tanggal pencairan, status (cair/belum).
Laporan: id laporan, id proposal (FK), jenis laporan (kemajuan/akhir), file laporan, tanggal unggah.
Luaran: id luaran, id proposal (FK), jenis luaran, judul/keterangan, bukti dokumen/link.

7. Pembagian Tugas Anggota

NamaNIMPeranTugas Utama
Muhammad Ridho Faizal2301020124Analis Kebutuhan & KoordinatorMenyusun deskripsi studi kasus, latar belakang, identifikasi aktor, dan kebutuhan fungsional dari sisi data; mengoordinasikan progres tim; menyusun dokumentasi laporan akhir.
Ragil Novant2301020098Perancang ERD & NormalisasiMengidentifikasi entitas dan atribut secara rinci, merancang ERD (kardinalitas dan relasi antartabel), serta melakukan proses normalisasi (1NF, 2NF, 3NF) untuk menghindari redundansi data.
Akbar Rahmat Arifin2301020055Implementasi Skema & QueryMenerjemahkan ERD ke dalam skema tabel fisik (DDL: CREATE TABLE, primary key, foreign key), membuat data dummy, serta menyusun contoh query (SELECT, JOIN, agregasi) untuk kebutuhan pelaporan.
