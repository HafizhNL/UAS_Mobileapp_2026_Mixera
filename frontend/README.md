# MIXÉRA — Frontend (Flutter)

Aplikasi mobile pembeli + mode seller; API memakai backend Django di folder `../backend`.

## Mulai

1. Salin `.env.example` → `.env` dan set **`API_BASE_URL`** (mis. `http://10.0.2.2:8000` untuk emulator Android menuju host).
2. `flutter pub get`
3. `flutter run`

## Dokumentasi per fitur

Setiap modul UI utama punya **`README.md`** di dalam foldernya:

`lib/features/<nama_fitur>/README.md` — isi: tujuan fitur, lapisan `data` / `presentation`, prefix API yang dipakai.

## Jaringan & auth

- Ringkasan interceptor token: `lib/core/network/README.md`.

## Fase siap demo (centang sampai selesai)

Ikuti urutan ini; demo dianggap **siap** setelah Fase 1–3 selesai. Fase 4–5 opsional.

- [ ] **Fase 1 — Lingkungan jalan**  
  Salin `.env` dari `.env.example`, set `API_BASE_URL`, jalankan `flutter pub get` dan `flutter run`. App harus terbuka tanpa crash di emulator/device yang dipakai demo.

- [ ] **Fase 2 — Bukti tes otomatis**  
  Dari folder `frontend/`, jalankan `flutter test` sampai **All tests passed** (cakupan di `test/`).

- [ ] **Fase 3 — Alur manual demo**  
  Backend + akun sesuai skenario. Uji sekali end-to-end alur yang akan ditampilkan (mis. login → shop → cart → checkout sesuai yang dipresentasikan).

- [ ] **Fase 4 — (Opsional) Integrasi**  
  Hanya jika diminta: `flutter test integration_test/...` pada device/emulator dengan harness yang siap.

- [ ] **Fase 5 — (Opsional) Materi presentasi**  
  Slide atau cuplikan layar: perintah `flutter test`, fitur utama, struktur `lib/features/...`.

**Ringkas perintah demo teknis**

```bash
cd frontend
flutter pub get
flutter test
flutter run
```
