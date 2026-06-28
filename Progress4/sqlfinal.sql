CREATE DATABASE db_uassbd;
USE db_uassbd;

CREATE TABLE dosen (
Nidn VARCHAR(20)  PRIMARY KEY,
nama VARCHAR(100) NOT NULL,
program_studi VARCHAR(100) NOT NULL,
fakultas VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
no_hp VARCHAR(20)
);

CREATE TABLE skema (
id_skema INT PRIMARY KEY AUTO_INCREMENT,
nama_skema VARCHAR(100) NOT NULL,
jenis ENUM('penelitian','pengabdian') NOT NULL,
tahun_anggaran INT          NOT NULL,
kuota_dana DECIMAL(15,2) NOT NULL,
tanggal_buka DATE NOT NULL,
tanggal_tutup DATE NOT NULL
);

CREATE TABLE proposal (
id_proposal  INT          PRIMARY KEY AUTO_INCREMENT,
id_skema     INT          NOT NULL,
judul        VARCHAR(255) NOT NULL,
ringkasan    TEXT,
status       ENUM('diajukan','direview','revisi','diterima','ditolak') NOT NULL DEFAULT 'diajukan',
tanggal_ajuan DATE        NOT NULL,
FOREIGN KEY (id_skema) REFERENCES skema(id_skema)
);

CREATE TABLE anggota_proposal (
id_anggota  INT         PRIMARY KEY AUTO_INCREMENT,
id_proposal INT         NOT NULL,
nidn        VARCHAR(20) NOT NULL,
peran       ENUM('ketua','anggota') NOT NULL,
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal),
FOREIGN KEY (nidn)        REFERENCES dosen(nidn)
);

CREATE TABLE rab (
id_rab       INT          PRIMARY KEY AUTO_INCREMENT,
id_proposal  INT          NOT NULL,
uraian_biaya VARCHAR(255) NOT NULL,
jumlah_biaya DECIMAL(15,2) NOT NULL,
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal)
);

CREATE TABLE reviewer (
id_reviewer     INT          PRIMARY KEY AUTO_INCREMENT,
nama            VARCHAR(100) NOT NULL,
bidang_keahlian VARCHAR(100) NOT NULL,
email           VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE review (
id_review    INT  PRIMARY KEY AUTO_INCREMENT,
id_proposal  INT  NOT NULL,
id_reviewer  INT  NOT NULL,
skor         INT  NOT NULL CHECK (skor BETWEEN 0 AND 100),
catatan      TEXT,
rekomendasi  ENUM('diterima','revisi','ditolak') NOT NULL,
tanggal_review DATE NOT NULL,
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal),
FOREIGN KEY (id_reviewer) REFERENCES reviewer(id_reviewer)
);

CREATE TABLE riwayat_status (
id_riwayat  INT  PRIMARY KEY AUTO_INCREMENT,
id_proposal INT  NOT NULL,
status ENUM('diajukan','direview','revisi','diterima','ditolak') NOT NULL,
tanggal_ubah DATE NOT NULL,
keterangan  TEXT,
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal)
);

CREATE TABLE kontrak (
id_kontrak   INT           PRIMARY KEY AUTO_INCREMENT,
id_proposal  INT           NOT NULL UNIQUE,
no_kontrak   VARCHAR(50)   NOT NULL UNIQUE,
nominal_dana DECIMAL(15,2) NOT NULL,
tanggal_ttd  DATE          NOT NULL,
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal)
);

CREATE TABLE termin_pencairan (
id_termin    INT           PRIMARY KEY AUTO_INCREMENT,
id_kontrak   INT           NOT NULL,
nomor_termin INT           NOT NULL,
jumlah_dana  DECIMAL(15,2) NOT NULL,
tanggal_cair DATE,
status_cair  ENUM('belum_cair','sudah_cair') NOT NULL DEFAULT 'belum_cair',
FOREIGN KEY (id_kontrak) REFERENCES kontrak(id_kontrak)
);

CREATE TABLE laporan (
id_laporan        INT  PRIMARY KEY AUTO_INCREMENT,
id_proposal       INT  NOT NULL,
jenis_laporan     ENUM('kemajuan','akhir') NOT NULL,
file_laporan      VARCHAR(255) NOT NULL,
tanggal_unggah    DATE NOT NULL,
status_verifikasi ENUM('menunggu','diverifikasi','ditolak') NOT NULL DEFAULT 'menunggu',
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal)
);

CREATE TABLE luaran (
id_luaran    INT  PRIMARY KEY AUTO_INCREMENT,
id_proposal  INT  NOT NULL,
jenis_luaran ENUM('publikasi_jurnal','HKI','prototipe','buku','lainnya') NOT NULL,
judul_luaran VARCHAR(255) NOT NULL,
bukti_dokumen VARCHAR(255),
FOREIGN KEY (id_proposal) REFERENCES proposal(id_proposal)
);

INSERT INTO dosen VALUES
('0101001', 'Budi Santoso', 'Teknik Lingkungan', 'Fakultas Teknik', 'budi@univ.ac.id', '081234567890'),
('0101002', 'Rina Dewi', 'Teknik Lingkungan', 'Fakultas Teknik', 'rina@univ.ac.id', '081234567891'),
('0101003', 'Sari Indah', 'Manajemen', 'Fakultas Ekonomi', 'sari@univ.ac.id', '081234567892'),
('0101004', 'Agus Widodo', 'Informatika', 'Fakultas Teknik', 'agus@univ.ac.id', '081234567893'),
('0101005', 'Dewi Lestari', 'Akuntansi', 'Fakultas Ekonomi', 'dewi@univ.ac.id', '081234567894');

INSERT INTO skema (nama_skema, jenis, tahun_anggaran, kuota_dana, tanggal_buka, tanggal_tutup) VALUES
('Penelitian Internal', 'penelitian', 2025, 500000000.00, '2025-01-01', '2025-01-31'),
('Pengabdian Masyarakat', 'pengabdian', 2025, 300000000.00, '2025-01-01', '2025-01-31'),
('Penelitian Unggulan', 'penelitian', 2025, 800000000.00, '2025-02-01', '2025-02-28');


INSERT INTO proposal (id_skema, judul, ringkasan, status, tanggal_ajuan) VALUES
(1, 'Analisis Kualitas Air Sungai Berbasis Sensor IoT', 'Penelitian ini bertujuan memantau kualitas air sungai menggunakan sensor IoT.', 'diterima', '2025-01-15'),
(2, 'Pelatihan Digital Marketing untuk UMKM Pesisir', 'Pengabdian ini bertujuan meningkatkan kemampuan digital marketing pelaku UMKM.', 'diterima', '2025-01-16'),
(1, 'Optimasi Pengolahan Limbah Industri Tekstil', 'Penelitian mengenai metode pengolahan limbah cair industri tekstil.', 'direview', '2025-01-20'),
(3, 'Pengembangan Sistem Informasi Desa Berbasis Web', 'Penelitian pengembangan sistem informasi untuk pemerintahan desa.', 'ditolak', '2025-02-10'),
(2, 'Pemberdayaan Ibu Rumah Tangga melalui Keterampilan Batik', 'Pengabdian berupa pelatihan membatik untuk ibu rumah tangga.', 'diajukan', '2025-01-28');

INSERT INTO anggota_proposal (id_proposal, nidn, peran) VALUES
(1, '0101001', 'ketua'),
(1, '0101002', 'anggota'),
(2, '0101003', 'ketua'),
(3, '0101004', 'ketua'),
(3, '0101001', 'anggota'),
(4, '0101004', 'ketua'),
(5, '0101005', 'ketua'),
(5, '0101003', 'anggota');

INSERT INTO rab (id_proposal, uraian_biaya, jumlah_biaya) VALUES
(1, 'Honorarium peneliti', 5000000.00),
(1, 'Pembelian sensor IoT', 7000000.00),
(1, 'Transport lapangan', 1500000.00),
(1, 'ATK dan laporan', 500000.00),
(2, 'Honorarium narasumber', 3000000.00),
(2, 'Konsumsi peserta', 2000000.00),
(2, 'Materi pelatihan', 1500000.00),
(3, 'Honorarium peneliti', 4000000.00),
(3, 'Bahan kimia analisis', 3500000.00);

INSERT INTO reviewer (nama, bidang_keahlian, email) VALUES
('Ahmad Fauzi', 'Teknik Lingkungan', 'ahmad.fauzi@reviewer.ac.id'),
('Budi Hartono', 'Manajemen Bisnis', 'budi.hartono@reviewer.ac.id'),
('Citra Wulandari', 'Sistem Informasi', 'citra@reviewer.ac.id');

INSERT INTO review (id_proposal, id_reviewer, skor, catatan, rekomendasi, tanggal_review) VALUES
(1, 1, 88, 'Proposal sangat relevan dan metodologi sudah tepat.', 'diterima', '2025-02-01'),
(2, 2, 80, 'Sasaran pengabdian jelas dan kebutuhan mitra terpenuhi.', 'diterima', '2025-02-02'),
(3, 1, 72, 'Perlu perbaikan pada bagian metodologi dan anggaran.', 'revisi', '2025-02-05'),
(4, 3, 55, 'Ruang lingkup terlalu luas, tidak fokus pada satu masalah.', 'ditolak', '2025-02-12');

INSERT INTO riwayat_status (id_proposal, status, tanggal_ubah, keterangan) VALUES
(1, 'diajukan', '2025-01-15', 'Proposal pertama kali diajukan'),
(1, 'direview', '2025-01-20', 'Proposal ditetapkan reviewernya'),
(1, 'diterima', '2025-02-03', 'Proposal diterima berdasarkan hasil review'),
(2, 'diajukan', '2025-01-16', 'Proposal pertama kali diajukan'),
(2, 'direview', '2025-01-21', 'Proposal ditetapkan reviewernya'),
(2, 'diterima', '2025-02-04', 'Proposal diterima berdasarkan hasil review'),
(3, 'diajukan', '2025-01-20', 'Proposal pertama kali diajukan'),
(3, 'direview', '2025-01-25', 'Proposal ditetapkan reviewernya'),
(4, 'diajukan', '2025-02-10', 'Proposal pertama kali diajukan'),
(4, 'ditolak', '2025-02-13', 'Proposal ditolak karena ruang lingkup terlalu luas');

INSERT INTO kontrak (id_proposal, no_kontrak, nominal_dana, tanggal_ttd) VALUES
(1, 'K/001/2025', 14000000.00, '2025-02-10'),
(2, 'K/002/2025', 6500000.00, '2025-02-11');

INSERT INTO termin_pencairan (id_kontrak, nomor_termin, jumlah_dana, tanggal_cair, status_cair) VALUES
(1, 1, 8400000.00, '2025-02-15', 'sudah_cair'),
(1, 2, 5600000.00, NULL, 'belum_cair'),
(2, 1, 3900000.00, '2025-02-16', 'sudah_cair'),
(2, 2, 2600000.00, NULL, 'belum_cair');

INSERT INTO laporan (id_proposal, jenis_laporan, file_laporan, tanggal_unggah, status_verifikasi) VALUES
(1, 'kemajuan', 'laporan_kemajuan_prop1.pdf', '2025-04-01', 'diverifikasi'),
(2, 'kemajuan', 'laporan_kemajuan_prop2.pdf', '2025-04-02', 'diverifikasi'),
(1, 'akhir', 'laporan_akhir_prop1.pdf', '2025-07-01', 'menunggu');

INSERT INTO luaran (id_proposal, jenis_luaran, judul_luaran, bukti_dokumen) VALUES
(1, 'publikasi_jurnal', 'Pemantauan Kualitas Air Sungai Berbasis IoT', 'bukti_jurnal_prop1.pdf'),
(2, 'prototipe', 'Modul Pelatihan Digital Marketing UMKM', 'modul_pelatihan_prop2.pdf'),
(1, 'HKI', 'Sistem Sensor Kualitas Air', 'sertifikat_hki_prop1.pdf');

QUERY 1: Menampilkan seluruh data dosen
SELECT nidn, nama, program_studi, fakultas, email
FROM dosen
ORDER BY nama ASC;

QUERY 2: Menampilkan proposal beserta nama skema
SELECT
p.id_proposal,
p.judul,
s.nama_skema,
s.jenis,
s.tahun_anggaran,
p.status,
p.tanggal_ajuan
FROM proposal p
JOIN skema s ON p.id_skema = s.id_skema
ORDER BY p.tanggal_ajuan DESC;

QUERY 3: Menampilkan dosen beserta proposal yang diajukan(termasuk peran sebagai ketua atau anggota)
SELECT
d.nidn,
d.nama,
d.program_studi,
p.judul AS judul_proposal,
ap.peran,
p.status
FROM dosen d
JOIN anggota_proposal ap ON d.nidn = ap.nidn
JOIN proposal p ON ap.id_proposal = p.id_proposal
ORDER BY d.nama, p.id_proposal;

QUERY 4: Menampilkan hasil review beserta nama reviewer dan judul proposal
SELECT
r.id_review,
p.judul AS judul_proposal,
rv.nama AS nama_reviewer,
r.skor,
r.rekomendasi,
r.catatan,
r.tanggal_review
FROM review r
JOIN proposal p  ON r.id_proposal  = p.id_proposal
JOIN reviewer rv ON r.id_reviewer  = rv.id_reviewer
ORDER BY r.tanggal_review;

QUERY 5: Menampilkan total anggaran RAB per proposal
SELECT
p.id_proposal,
p.judul,
SUM(rb.jumlah_biaya) AS total_anggaran,
COUNT(rb.id_rab)     AS jumlah_butir_rab
FROM proposal p
JOIN rab rb ON p.id_proposal = rb.id_proposal
GROUP BY p.id_proposal, p.judul
ORDER BY total_anggaran DESC;

QUERY 6: Menampilkan proposal yang berstatus diterima beserta info kontrak
SELECT
p.id_proposal,
p.judul,
p.status,
k.no_kontrak,
k.nominal_dana,
k.tanggal_ttd
FROM proposal p
LEFT JOIN kontrak k ON p.id_proposal = k.id_proposal
WHERE p.status = 'diterima';

QUERY 7: Rekap jumlah proposal per skema per tahun
SELECT
s.nama_skema,
s.jenis,
s.tahun_anggaran,
COUNT(p.id_proposal)  AS total_proposal,
SUM(CASE WHEN p.status = 'diterima' THEN 1 ELSE 0 END) AS proposal_diterima,
SUM(CASE WHEN p.status = 'ditolak'  THEN 1 ELSE 0 END) AS proposal_ditolak
FROM skema s
LEFT JOIN proposal p ON s.id_skema = p.id_skema
GROUP BY s.id_skema, s.nama_skema, s.jenis, s.tahun_anggaran
ORDER BY s.tahun_anggaran, s.nama_skema;

QUERY 8: Status pencairan dana per kontrak
SELECT
k.no_kontrak,
p.judul AS judul_proposal,
k.nominal_dana,
tp.nomor_termin,
tp.jumlah_dana,
tp.tanggal_cair,
tp.status_cair
FROM kontrak k
JOIN proposal p          ON k.id_proposal  = p.id_proposal
JOIN termin_pencairan tp ON k.id_kontrak   = tp.id_kontrak
ORDER BY k.no_kontrak, tp.nomor_termin;

QUERY 9: Update status proposal menjadi 'revisi' dan catat perubahan ke riwayat_status
UPDATE proposal
SET status = 'revisi'
WHERE id_proposal = 3;

INSERT INTO riwayat_status (id_proposal, status, tanggal_ubah, keterangan)
VALUES (3, 'revisi', CURDATE(), 'Diminta revisi oleh reviewer berdasarkan hasil penilaian');

QUERY 10: Menampilkan dosen yang BELUM pernah mengajukan proposal (menggunakan LEFT JOIN)
SELECT
d.nidn,
d.nama,
d.program_studi,
d.fakultas
FROM dosen d
LEFT JOIN anggota_proposal ap ON d.nidn = ap.nidn
WHERE ap.id_anggota IS NULL
ORDER BY d.nama;
