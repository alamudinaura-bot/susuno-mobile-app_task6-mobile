# SUSUNO - Warehouse Management System App
**SUSUNO** adalah aplikasi mobile manajemen pergudangan berbasis Flutter yang dirancang untuk kebutuhan pemantauan stok real-time, pencatatan transaksi masuk/keluar (*Inbound/Outbound*), serta manajemen tugas inventaris.

Aplikasi ini dikembangkan untuk memenuhi tugas **Slicing UI & Implementation of Global State Management** dengan arsitektur **MVC (Model-View-Controller)**.

---

## Fitur Utama

- 📊 **Real-time Inventory Telemetry (Dashboard)**:
  - Ringkasan total SKU aktif dan unit stok.
  - Telemetry *Inbound* & *Outbound* harian yang terhubung langsung dengan *Global State*.
  - Pemantauan stok kritis (*Critical Stock Monitoring*), *AI Insights*, dan riwayat audit aktivitas gudang (*Audit Trail*).
- 📦 **Stock Monitoring (`stock_screen.dart`)**:
  - Daftar lengkap seluruh item barang beserta lokasi rak/bin.
  - Indikator visual otomatis (Merah/Hijau) jika stok berada di bawah batas aman (*Below Safe Stock*).
- 📲 **Barcode/QR Scanner UI (`scanner_screen.dart`)**:
  - Simulasi pemindaian barang untuk *Stock In* dan *Stock Out*.
  - Pengaturan jumlah kuantitas fisik (*Physical Count*) secara cepat (+1, +5, +10).
  - Integrasi transaksi langsung ke *Global State Provider*.

  **Link Figma:** https://www.figma.com/design/bOItSVev14w046phVcUEiI/Untitled?node-id=0-1&p=f&t=rNWr82jjl3Jt4Sf2-0
   