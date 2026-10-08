# Escape penacony standalone (Android APK) 📱📦

โฟลเดอร์นี้เป็นส่วนเอกสารและพอยน์เตอร์สำหรับ **Escape penacony standalone** (แอปพลิเคชัน Native Android สำหรับจัดการฉากและวาร์ปแมพบนอุปกรณ์ Android โดยตรง)

---

## 🔗 ที่อยู่ของ Source Code (Dedicated Repository)

ซอร์สโค้ดและโปรเจกต์ Android Studio ของแอปพลิเคชันถูกแยกออกไปพัฒนาและจัดการใน Repository เฉพาะ:
- **Repository**: [`Escape-penacony-standalone`](https://www.youtube.com/watch?v=QDia3e12czc)
---

## 🌟 ฟีเจอร์ของแอปพลิเคชัน (Key Features)

- **Native Material Design 3 Touch UI**: สวยงาม ลื่นไหล ใช้งานง่ายบนหน้าจอสัมผัส
- **8 ดวงดาว 85 ฉาก**: ครอบคลุมพิกัดครบถ้วนจากฐานข้อมูล `scenes.json`
- **ระบบเลือกและบันทึกไฟล์ปลอดภัย**: ใช้ Android Storage Access Framework (SAF) เข้าถึง `persistent.json` ได้ทุกเวอร์ชัน (Android 8 - 15+)
- **In-App Auto-Updater**: ระบบตรวจจับเวอร์ชันใหม่ผ่าน GitHub Releases API และติดตั้ง APK อัตโนมัติ (ตามแบบ FFGO)
- **Hot-Data Sync (OTA)**: อัปเดตพิกัดแมพใหม่จาก GitHub ได้ทันทีโดยไม่ต้องติดตั้ง APK ใหม่
- **รองรับ 3 ภาษา**: English (EN), ภาษาไทย (TH), และ 简体中文 (ZH)

---

## 📥 การดาวน์โหลดและติดตั้ง

เมื่อมีเวอร์ชันใหม่ สามารถดาวน์โหลดไฟล์ `.apk` ได้จากหน้า [Releases](https://github.com/CAtlas0784/Escape-penacony/releases) หรือหน้า Releases ของโปรเจกต์หลัก

> สำหรับการใช้งานบน Terminal / Command Line ในระบบปฏิบัติการ Android สามารถดูวิธีการใช้งานผ่าน Termux ได้ที่โฟลเดอร์ [`Android Termux/`](../Android%20Termux/)
