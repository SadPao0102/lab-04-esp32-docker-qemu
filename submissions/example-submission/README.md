# Lab 04 Submission - ESP32 Docker QEMU

**Student Information:**
- Student ID: 65123456
- Name: John Doe
- Section: Section 1

## สรุปการทำงาน

### ผลการดำเนินงาน
- ✅ สร้าง Docker environment สำหรับ ESP32 สำเร็จ
- ✅ พัฒนาโปรแกรม Hello World ได้สำเร็จ
- ✅ จำลองการทำงานด้วย QEMU สำเร็จ
- ✅ ใช้ GDB สำหรับ debugging ได้
- ✅ จัดทำรายงานครบถ้วน

### ปัญหาที่พบและการแก้ไข

#### ปัญหา 1: Docker build ช้า
**สาเหตุ:** การดาวน์โหลด ESP-IDF image ขนาดใหญ่
**วิธีแก้:** ใช้ Docker layer caching และรอให้ดาวน์โหลดเสร็จ

#### ปัญหา 2: QEMU ไม่แสดงผล
**สาเหตุ:** ไม่ได้ใส่ `-nographic` flag
**วิธีแก้:** เพิ่ม parameter ที่จำเป็นในคำสั่ง QEMU

#### ปัญหา 3: GDB เชื่อมต่อไม่ได้
**สาเหตุ:** QEMU ไม่ได้เปิด debug port
**วิธีแก้:** ใช้ `-s -S` flags ใน QEMU command

### สิ่งที่ได้เรียนรู้
1. การใช้ Docker สำหรับ embedded development
2. กระบวนการ build และ debug ESP32
3. การใช้ QEMU สำหรับจำลอง hardware
4. การทำงานของ ESP-IDF framework

### ข้อเสนอแนะ
1. ควรมีคำแนะนำเกี่ยวกับการแก้ไข network issues
2. อาจเพิ่มตัวอย่างโปรแกรมที่ซับซ้อนกว่า Hello World
3. ควรมี troubleshooting guide ที่ละเอียดมากขึ้น

## ไฟล์ที่ส่ง

### ไฟล์เอกสาร
- `report.pdf` - รายงานการทดลองฉบับสมบูรณ์
- `README.md` - ไฟล์นี้

### ไฟล์โค้ด
- `code/` - โค้ดโปรแกรมทั้งหมด
  - `hello_world/` - โปรเจ็กต์ ESP32
  - `Dockerfile` - การตั้งค่า Docker
  - `docker-compose.yml` - Docker services
  - `Makefile` - Build automation

### ไฟล์มีเดีย
- `screenshots/` - รูปภาพหน้าจอ
  - `docker-build-success.png`
  - `qemu-simulation.png`
  - `gdb-debugging.png`
  - `project-structure.png`
- `video_demo.mp4` - วิดีโอสาธิตการทำงาน

## เวลาที่ใช้
- การศึกษาและเตรียมความพร้อม: 2 ชั่วโมง
- การติดตั้งและตั้งค่า Docker: 1 ชั่วโมง
- การพัฒนาโปรแกรมและทดสอบ: 3 ชั่วโมง
- การจัดทำรายงาน: 2 ชั่วโมง
- **รวม: 8 ชั่วโมง**

## คะแนนประเมินตนเอง
- ความสมบูรณ์ของงาน: 95%
- ความเข้าใจเนื้อหา: 90%
- คุณภาพรายงาน: 90%
- การทำงานตามกำหนดเวลา: 100%
