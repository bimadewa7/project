# Rencana Penggabungan Multi-Halaman HTML Menjadi 1 Single HTML (SPA)

Menggabungkan seluruh halaman portofolio (`index.html`, `bio.html`, `expertise.html`, `achievements.html`, `gallery.html`, `contact.html`) ke dalam satu dokumen HTML tunggal (`index.html`) untuk menghasilkan transisi halaman yang instan, elegan, tanpa kedip/reload (flicker-free), serta memastikan pemutaran musik di latar belakang berjalan secara kontinu 100% tanpa putus.

---

## Gambaran Arsitektur

Saat ini portofolio terbagi menjadi 6 file HTML terpisah:
1. `index.html`: Animasi splash screen pembuka multibahasa ("Hello World", "Halo Dunia", dll).
2. `bio.html`: Halaman Overview (Profil, statistik, riwayat pendidikan, CTA).
3. `expertise.html`: Keahlian akuntansi, tools, kurikulum, dan sertifikasi.
4. `achievements.html`: Prestasi kompetisi & riwayat pelatihan dengan accordion timeline & filter kategori.
5. `gallery.html`: Galeri foto bento grid interaktif dengan lightbox modal.
6. `contact.html`: Formulir kontak interaktif dan kartu copy-to-clipboard.

### Masalah Arsitektur Lama
- Perpindahan antar file HTML terpisah memerlukan permintaan jaringan / navigasi browser yang memicu kedipan putih/layar kosong sesaat (screen flash) dan menghentikan pemutaran audio di memori.
- `music-player.js` sebelumnya mencoba teknik `fetch()` partial DOM swap, tetapi memiliki keterbatasan: gagal pada protokol lokal `file://` (CORS), memicu reflow layout besar, dan script halaman harus di-mount ulang secara paksa.

### Solusi: Arsitektur Single Page HTML
- **1 Dokumen Bersatu (`index.html`)**:
  - Menyimpan splash screen awal, sticky header navigasi, footer bersama, dan seluruh seksi konten (`#overview`, `#expertise`, `#achievements`, `#gallery`, `#contact`) langsung di dalam DOM.
  - Seksi aktif ditampilkan dengan transisi animasi halus (`opacity`, `transform: translateY/scale`, dan `filter: blur()`), sementara seksi yang tidak aktif disembunyikan secara bersih (`hidden` atau `display: none`).
  - URL browser disinkronkan menggunakan hash `#overview`, `#expertise`, `#achievements`, `#gallery`, `#contact`, sehingga mendukung tombol *Back* & *Forward* browser, serta dapat di-bookmark/dibagikan langsung ke seksi tertentu.
  - Audio player (`music-player.js`) berjalan di level dokumen yang sama tanpa pernah di-reload, menghasilkan musik nonstop 100%.

---

## User Review Required

> [!IMPORTANT]
> **Struktur File Lama vs File Baru:**
> File utama website akan terpusat di `index.html`. File-file lama (`bio.html`, `expertise.html`, `achievements.html`, `gallery.html`, `contact.html`) akan diubah menjadi **redirect shim** ringan (mengarahkan otomatis ke `index.html#nama-halaman`). Dengan demikian, jika ada bookmark atau link eksternal lama, pengunjung tetap langsung masuk ke halaman yang tepat tanpa error 404.

---

## Proposed Changes

### 1. Struktur Dokumen Tunggal (`index.html`)

#### [MODIFY] [index.html](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/index.html)
- **Head & Styling**: Menggabungkan seluruh meta tag, konfigurasi Tailwind, font Google (`Space Grotesk`, `Inter`, `JetBrains Mono`), dan style spesifik dari setiap halaman ke dalam satu stylesheet konsisten.
- **Splash Screen**:
  - Animasi pembuka multibahasa dipertahankan sebagai overlay transisi awal.
  - Setelah selesai (~0.95s), splash screen memudar mulus (`fade-out` & `scale-down`) lalu mengungkap tampilan portofolio.
  - Jika pengunjung mengakses URL dengan hash tertentu (contoh: `index.html#contact`), splash screen dapat langsung melompat atau selesai lebih cepat.
- **Unified Header & Navigation**:
  - Satu sticky header bersama dengan logo monograf "Dv" dan link navigasi (`#overview`, `#expertise`, `#achievements`, `#gallery`, `#contact`).
  - State indikator aktif (kinetic underline & highlight) otomatis berpindah saat seksi berganti.
  - Drawer menu mobile yang responsif dan otomatis menutup saat link diklik.
- **Section Containers**:
  - `<section id="view-overview" class="spa-view">`: Konten profil dari `bio.html`.
  - `<section id="view-expertise" class="spa-view hidden">`: Konten keahlian dari `expertise.html`.
  - `<section id="view-achievements" class="spa-view hidden">`: Konten linimasa prestasi & filter dari `achievements.html`.
  - `<section id="view-gallery" class="spa-view hidden">`: Bento grid foto dari `gallery.html`.
  - `<section id="view-contact" class="spa-view hidden">`: Formulir kontak & kartu copy dari `contact.html`.
- **Global Modals & Components**:
  - Modal Lightbox foto galeri (beserta navigasi keyboard Esc, panah kiri/kanan).
  - Footer terpadu dengan dynamic year.
  - Script player musik continuous (`music-player.js`).

---

### 2. Efek Transisi Halus (Smooth View Transitions)

#### [MODIFY] [styles.css](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/styles.css)
- Menambahkan kelas animasi transisi antar view SPA:
  ```css
  .spa-view {
    opacity: 1;
    transform: translateY(0) scale(1);
    filter: blur(0);
    transition: opacity 0.35s cubic-bezier(0.16, 1, 0.3, 1),
                transform 0.35s cubic-bezier(0.16, 1, 0.3, 1),
                filter 0.35s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .spa-view.view-entering {
    opacity: 0;
    transform: translateY(12px) scale(0.985);
    filter: blur(6px);
  }
  .spa-view.view-leaving {
    opacity: 0;
    transform: translateY(-8px) scale(0.99);
    filter: blur(4px);
    pointer-events: none;
  }
  ```
- Memanfaatkan API modern `document.startViewTransition()` jika didukung oleh browser untuk transisi morfologi yang sangat halus, dengan fallback otomatis ke animasi CSS di atas.

---

### 3. Logika Navigasi & Router Klien

#### [MODIFY] [music-player.js](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/music-player.js)
- Menghapus logika lama yang mencoba melakukan `fetch()` file HTML eksternal.
- Mengintegrasikan router berbasis hash internal:
  - Mendengarkan event `hashchange` dan klik pada link navigasi (`a[href^="#"]`).
  - Menjalankan fungsi `switchView(targetId)`:
    1. Memulai animasi keluar (`view-leaving`) pada seksi aktif saat ini.
    2. Menampilkan seksi target dengan status `view-entering` lalu bertransisi mulus ke posisi penuh.
    3. Memperbarui styling tombol navigasi (desktop & mobile).
    4. Menggulirkan layar ke paling atas secara mulus (`window.scrollTo({ top: 0, behavior: 'instant' })`).
    5. Menjalankan kembali observer interaktif (animasi counter angka pada overview, scroll reveal, dsb).
- Menjamin pemutar audio tetap berputar tanpa interupsi apapun.

---

### 4. Kompatibilitas Tautan Lama (Backward-Compatible Redirects)

#### [MODIFY] [bio.html](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/bio.html)
#### [MODIFY] [expertise.html](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/expertise.html)
#### [MODIFY] [achievements.html](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/achievements.html)
#### [MODIFY] [gallery.html](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/gallery.html)
#### [MODIFY] [contact.html](file:///d:/pemprogaman_web/portog_gray/portofolio%20-%20Copy/contact.html)
- Setiap file diubah menjadi halaman redirect instan ke `index.html#<seksi>` (menggunakan `<meta http-equiv="refresh">` dan `window.location.replace()`), sehingga bookmark pengguna atau link terdahulu tidak akan rusak.

---

## Verification Plan

### Automated / Browser Verification
1. **Verifikasi Tampilan Awal & Splash Screen**:
   - Membuka `index.html` di browser subagent / preview.
   - Memastikan splash text multibahasa muncul dan bertransisi mulus ke seksi `#overview`.
2. **Pengujian Transisi Antar Halaman (Smoothness Check)**:
   - Klik navigasi: Overview -> Expertise -> Achievements -> Gallery -> Contact.
   - Memastikan transisi halus tanpa flicker putih, tanpa jeda loading, dan scroll kembali rapi ke atas.
3. **Pengujian Pemutar Musik (Audio Continuity)**:
   - Memulai lagu di music player.
   - Melakukan navigasi cepat antar seksi menu.
   - Memastikan lagu tetap berputar terus-menerus tanpa jeda (seamless continuous audio).
4. **Pengujian Interaktivitas Komponen**:
   - Filter linimasa di Achievements (All, Competitions, Trainings).
   - Accordion dropdown di Achievements.
   - Lightbox foto di Gallery (buka, navigasi keyboard panah, tutup dengan Esc).
   - Copy to clipboard & validasi submit form di Contact.
   - Counter angka di Overview berjalan ketika seksi terlihat.
5. **Pengujian Responsivitas Mobile**:
   - Cek menu hamburger pada layar mobile, pastikan drawer terbuka dan otomatis menutup saat link ditekan.
