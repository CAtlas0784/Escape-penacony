# this is just for u to know that i will do it someday
## ppSR Map Teleporter - Android Standalone APK (Placeholder / Coming Soon) 📱📦

โฟลเดอร์นี้จัดเตรียมไว้สำหรับการพัฒนาและเผยแพร่ **Standalone Android APK (`.apk`)** ของเครื่องมือ **Escape Penacony (ppSR Scene & Map Teleporter)**

---

## 🎯 เป้าหมายการพัฒนา (Development Goals)

- **Native Graphical UI**: หน้าต่างแอปพลิเคชันระบบสัมผัส (Touch UI) พร้อม Material Design 3 ไม่ต้องใช้ Terminal หรือพิมพ์คำสั่ง
- **Ultra Lightweight (~2 - 4 MB)**: พัฒนาด้วย Native Android (Kotlin / Jetpack Compose) ไม่ฝัง Python Runtime ขนาดใหญ่ ทำให้แอปเบา ลื่นไหล และเปิดใช้งานได้ทันที
- **Safe Storage Access**: ใช้ Android Storage Access Framework (SAF) ในการเลือกและบันทึกไฟล์ `persistent.json` รองรับ Android 10, 11, 12, 13, 14, และ 15+
- **Full Data Parity**: ใช้ฐานข้อมูล `scenes.json` ชุดเดียวกับเวอร์ชัน PC (PowerShell) และ Termux:
  - แยกโหมด **Combat Ready** (มีเสา Calyx แท้) และ **Exploration** (ซ่อนเสาใต้ดิน Y=-999999)
  - แยกป้ายกำกับชัดเจนระหว่าง **`[Product]`** (ตัวเกมทางการ) และ **`[🧪 4.7 Beta]`** (ตัวเกมเบต้า)
  - รองรับ 3 ภาษาเต็มรูปแบบ: **English**, **ภาษาไทย**, **简体中文**

---

## 🏗️ โครงสร้างโปรเจกต์ที่วางแผนไว้ (Planned Architecture)

```text
Android APK/
├── README.md               # เอกสารโครงการ (ไฟล์นี้)
├── app/                    # ซอร์สโค้ด Native Android (Kotlin)
│   ├── build.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── assets/
│       │   └── scenes.json  # ฐานข้อมูลแผนที่ 8 โลก 85 แมพ
│       ├── java/com/ppsr/teleport/
│       │   ├── MainActivity.kt
│       │   ├── model/       # Data classes (Planet, Scene)
│       │   └── ui/          # Compose UI screens
│       └── res/
├── build.gradle.kts
└── settings.gradle.kts
```

---

## ⏳ สถานะปัจจุบัน (Current Status)

> 🚧 **Work in Progress**: ขณะนี้โครงสร้างโฟลเดอร์ถูกสร้างขึ้นเพื่อเตรียมพร้อมสำหรับการพัฒนา สำหรับผู้ใช้งานบนระบบปฏิบัติการ Android ในปัจจุบัน สามารถใช้งานเวอร์ชัน CLI ผ่านแอป Termux ในโฟลเดอร์ [`Android Termux/`](../Android%20Termux/) ได้ทันที
