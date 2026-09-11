# Moody Indie-Band Inspired Portfolio Redesign

Redesain pengalaman web portfolio Bima Arya Dewa agar terasa lebih cinematic, atmospheric, dan moody — terinspirasi dari estetika visual The Neighbourhood & Arctic Monkeys. Fokus pada **transisi yang lebih smooth**, **tipografi yang nyaman**, dan **dekorasi/animasi subtle** yang membuat web hidup tanpa berlebihan.

## Design Direction

Mengambil vibe dari:
- **The Neighbourhood** — B&W grainy, noir, brooding minimalism, desaturated palette
- **Arctic Monkeys** — Typographic confidence, cinematic pacing, retro-modern editorial feel

### Palette (tetap monochrome, ditambah grain & depth)
Mempertahankan palette gelap `#0B0B0C` yang sudah ada, tapi menambahkan:
- Subtle **film grain overlay** sebagai texture layer (CSS noise pattern)
- **Smoke/fog glow** — ambient radial gradients yang bergerak pelan
- Warm muted accent `#A0938A` (dusty rose-clay) menggantikan gold references yang tidak terpakai

### Tipografi yang Lebih Nyaman
- **Heading**: Beralih dari `Inter` (geometric sans) ke **Space Grotesk** — lebih ekspresif, geometric tapi ada karakter, cocok untuk vibes indie
- **Body**: Beralih ke **Inter** dengan weight 300-400 dan increased line-height (1.7-1.8) untuk kenyamanan baca
- **Accent/Mono**: **JetBrains Mono** — lebih readable dari generic monospace
- Font size body diperbesar dari default ke `16-17px` base

## Proposed Changes

### Global Stylesheet — [NEW] [styles.css](file:///d:/pemprogaman_web/portog_gray/portofolio/styles.css)

Membuat file CSS terpisah yang di-share semua halaman. Berisi:

1. **Film Grain Overlay** — `body::after` pseudo-element dengan animated noise texture (CSS only, no image)
2. **Smooth Page Transitions** — Upgrade `.reveal` animations:
   - Staggered reveal dengan delay berbeda per child (`.reveal-stagger`)
   - Ease curve dari `ease` → `cubic-bezier(0.16, 1, 0.3, 1)` (easeOutExpo) agar terasa lebih cinematic
   - Durasi naik ke 1s untuk feel yang lebih deliberate & moody
3. **Floating Fog Glow** — Ambient background orbs yang bergerak perlahan dengan `@keyframes drift`
4. **Custom Scrollbar** — Thin, dark scrollbar yang match palette
5. **Nav Link Underline Animation** — Underline yang slide-in dari kiri saat hover (bukan instant)
6. **Header Blur-Glass** — `backdrop-filter: blur(20px) saturate(180%)` pada sticky header
7. **Selection Color** — Consistent warm muted highlight
8. **Cursor Glow** (desktop only) — Subtle radial gradient yang follow mouse (optional, ditangani JS)
9. **Text Reveal Animation** — Karakter/word yang "muncul naik" dari bawah satu per satu di heading (CSS `@keyframes slideUp`)

---

### Semua HTML Pages — MODIFY

Perubahan yang konsisten di **semua 5 halaman** ([bio.html](file:///d:/pemprogaman_web/portog_gray/portofolio/bio.html), [expertise.html](file:///d:/pemprogaman_web/portog_gray/portofolio/expertise.html), [achievements.html](file:///d:/pemprogaman_web/portog_gray/portofolio/achievements.html), [gallery.html](file:///d:/pemprogaman_web/portog_gray/portofolio/gallery.html), [contact.html](file:///d:/pemprogaman_web/portog_gray/portofolio/contact.html)):

1. **Google Fonts** — Ganti link ke `Space Grotesk` (heading) + `Inter` (body) + `JetBrains Mono` (mono)
2. **Tailwind Config** — Update `fontFamily` keys
3. **Link `styles.css`** — Tambahkan `<link>` ke shared stylesheet
4. **Header** — Tambahkan `backdrop-blur-xl bg-[#0B0B0C]/80` (glassmorphism), nav links mendapat slide-in underline class
5. **Nav Active State** — Ganti from class-toggle ke visible underline bar
6. **Reveal Stagger** — Tambahkan `style="--delay: Xs"` pada `.reveal` elements untuk staggered entrance
7. **Fog Elements** — Tambahkan 2-3 `<div class="fog-orb">` di background sections untuk atmospheric effect
8. **Typography Sizing** — Adjust body text line-height, heading sizes, letter-spacing
9. **Footer cleanup** — Hapus referensi `text-gold` yang undefined, ganti ke `text-[#A0938A]`

---

### [MODIFY] [index.html](file:///d:/pemprogaman_web/portog_gray/portofolio/index.html) (Splash Page)

- Upgrade typografi ke Space Grotesk
- Tambahkan film grain overlay
- Perbagus animasi "Hello World" multilingual — tambahkan blur-in/out per kata
- Tambahkan subtle breathing glow di center screen
- Transisi keluar lebih cinematic (1s ease-out vs 0.25s)

---

### [MODIFY] [bio.html](file:///d:/pemprogaman_web/portog_gray/portofolio/bio.html)

Selain perubahan global:
- Hero section: heading mendapat text-reveal animation (kata per kata naik)
- Profile photo card: tambahkan subtle hover parallax tilt effect (CSS `perspective` + `transform`)
- Stats ribbon: counter numbers mendapat typography upgrade + reveal animation

---

### [MODIFY] [gallery.html](file:///d:/pemprogaman_web/portog_gray/portofolio/gallery.html)

Selain perubahan global:
- Lightbox transition: fade+scale yang lebih smooth (0.4s cubic-bezier)
- Photo grid items: staggered reveal per image

---

> [!IMPORTANT]
> Semua perubahan dilakukan secara **additive** — tidak menghapus konten atau mengubah struktur halaman. Musik player (`music-player.js`) **tidak diubah** sama sekali.

## Open Questions

1. **Cursor glow effect** — Ingin menambahkan radial gradient halus yang mengikuti mouse di background? Ini menambah kesan "hidup" tapi bisa terasa berat di beberapa device. Boleh diskip jika tidak diinginkan.
2. **Font pairing** — Apakah **Space Grotesk** (heading) + **Inter** (body) cocok untuk selera kamu, atau lebih suka font yang lebih editorial seperti **Playfair Display** / serif?

## Verification Plan

### Manual Verification
- Buka setiap halaman di browser lokal, cek visual consistency
- Test transisi antar halaman (reveal animations, page transitions)
- Test mobile responsiveness
- Pastikan music player tidak terganggu
- Test lightbox gallery tetap smooth
