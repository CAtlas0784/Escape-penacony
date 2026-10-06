# ppSR Scene & Map Teleporter (Android / Termux Edition) 📱

เครื่องมือจัดการตำแหน่งและเทเลพอร์ตแมพสำหรับ **ppSR (Project Star Rail / 4.4.x - 4.7.x+)** บน **Android** ผ่าน **Termux**
รองรับ 3 ภาษาเต็มรูปแบบ: **English (EN)**, **ภาษาไทย (TH)**, และ **简体中文 (ZH)**

---

## 🚀 คุณสมบัติเด่น (Features)

- **Mobile Friendly UX:** ออกแบบมาสำหรับคีย์บอร์ดมือถือโดยเฉพาะ (Gboard, Samsung Keyboard) โดยใช้ระบบพิมพ์ตัวเลข `1`, `2`, `3...`, `b` เพื่อย้อนกลับ, `q` เพื่อออก ไม่ต้องใช้ปุ่มลูกศร (Arrow Keys)
- **Auto-Discovery:** ค้นหาไฟล์ `persistent.json` อัตโนมัติใน Path ยอดนิยมของ Termux และ Android Internal Storage (`/sdcard/ppSR/misc/persistent.json`, `~/ppSR/misc/persistent.json` ฯลฯ)
- **Calyx Safety Guard:** แมพสายสำรวจจะซ่อนเสาดอก Calyx ไว้ใต้ดินระดับลึก `Y = -999999` ป้องกันเกมค้างหรือตัวละครติดบั๊ก
- **Auto Backup:** สำรองไฟล์ `persistent.json.bak` อัตโนมัติทุกครั้งก่อนแก้ไข
- **Custom Coordinates:** รองรับการระบุ Plane ID และพิกัด X, Y, Z เองได้อย่างอิสระ
- **Trilingual Localization:** ฐานข้อมูลชื่อแมพครบถ้วนทั้งภาษาไทย, อังกฤษ และจีน (ขอบคุณ Oriyuki)

---

## 📋 ข้อกำหนดเบื้องต้น (Prerequisites)

1. **ติดตั้ง Termux:**
   - แนะนำให้ติดตั้งจาก **[F-Droid](https://f-droid.org/en/packages/com.termux/)** หรือ **[GitHub Releases](https://github.com/termux/termux-app/releases)**
   - ⚠️ *คำเตือน: ห้ามติดตั้ง Termux จาก Google Play Store เนื่องจากเป็นเวอร์ชันเก่าที่หยุดอัปเดตแล้ว*
2. **เปิดสิทธิ์การเข้าถึง Storage ใน Termux:**
   ```bash
   termux-setup-storage
   ```
   *(กดปุ่ม "Allow" / "อนุญาต" บนหน้าจอโทรศัพท์เมื่อมีข้อความแจ้งเตือน)*

---

## 📥 ขั้นตอนการติดตั้งและเปิดใช้งาน (Installation & Quick Start)

### 1. ติดตั้ง Python
เปิดแอป Termux แล้วรันคำสั่ง:
```bash
pkg update && pkg install python -y
```

### 2. นำโฟลเดอร์เครื่องมือไปวางใน Termux
คุณสามารถคัดลอกโฟลเดอร์ `Android/` จากคอมหรือโฟลเดอร์ Download มาไว้ใน Termux หรือเปิดใช้งานจากพาธที่วางไว้โดยตรง:
```bash
# ตัวอย่าง: หากวางไว้ใน Internal Storage /sdcard/Download
cd /sdcard/Download/Escape-penacony-tool/Android

# หรือหากวางไว้ใน Home Directory ของ Termux
cd ~/Escape-penacony-tool/Android
```

### 3. รันโปรแกรม (Run)
ให้สิทธิ์ Execute และรันสคริปต์ตัวเปิด:
```bash
chmod +x start.sh
./start.sh
```
*หรือสามารถรันด้วย Python โดยตรง:*
```bash
python3 teleport.py
```

---

## ⚙️ การตั้งค่า `persistent.json` (Configuration)

โปรแกรมจะค้นหาไฟล์ `persistent.json` โดยอัตโนมัติตามลำดับดังนี้:
1. `Android/persistent.json` (ในโฟลเดอร์ของเครื่องมือเอง)
2. `~/ppSR/misc/persistent.json`
3. `/sdcard/ppSR/misc/persistent.json`
4. `/sdcard/Download/ppSR/misc/persistent.json`

หากระบบหาไม่พบ หรือคุณเก็บไฟล์ไว้ที่อื่น:
- เลือกเมนู **`[P] Change persistent.json Path`**
- พิมพ์พาธของไฟล์ เช่น: `/sdcard/MyServer/misc/persistent.json`

---

## 🎮 วิธีการใช้งานเมนู (Controls)

- **`1` - `9`**: เลือกหมวดหมู่ / เลือกดวงดาว / เลือกแมพที่ต้องการเทเลพอร์ต
- **`B`**: ย้อนกลับไปยังเมนูก่อนหน้า (Back)
- **`Q` หรือ `X`**: ออกจากโปรแกรม (Quit / Exit)
- **`L`**: สลับภาษา (English / ภาษาไทย / 简体中文)
- **`4`**: โหมดพิมพ์พิกัดเอง (Custom Coordinates)
