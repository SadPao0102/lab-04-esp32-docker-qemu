# Grading Rubric - Lab 04: ESP32 Docker QEMU

## การประเมินผลการทดลอง

### คะแนนรวม: 100 คะแนน

---

## 1. Docker Environment Setup (25 คะแนน)

### 1.1 Dockerfile Configuration (10 คะแนน)
- **Excellent (9-10):** Dockerfile สมบูรณ์, มี comments อธิบาย, ใช้ best practices
- **Good (7-8):** Dockerfile ทำงานได้ถูกต้อง, มี structure ที่ดี
- **Satisfactory (5-6):** Dockerfile พื้นฐานทำงานได้
- **Needs Improvement (0-4):** Dockerfile มีปัญหาหรือไม่ทำงาน

### 1.2 Docker Compose (8 คะแนน)
- **Excellent (8):** docker-compose.yml สมบูรณ์ มี volumes, networks ถูกต้อง
- **Good (6-7):** ทำงานได้ดี มีการตั้งค่าที่เหมาะสม
- **Satisfactory (4-5):** ใช้งานได้ขั้นพื้นฐาน
- **Needs Improvement (0-3):** มีปัญหาในการทำงาน

### 1.3 Container Management (7 คะแนน)
- **Excellent (7):** Container ทำงานเสถียร, มี helper scripts
- **Good (5-6):** Container ทำงานได้ปกติ
- **Satisfactory (3-4):** Container ทำงานได้บางครั้ง
- **Needs Improvement (0-2):** Container มีปัญหา

---

## 2. ESP32 Development (25 คะแนน)

### 2.1 Project Creation (8 คะแนน)
- **Excellent (8):** สร้างโปรเจ็กต์ได้ถูกต้อง มี structure ที่ดี
- **Good (6-7):** โปรเจ็กต์ทำงานได้
- **Satisfactory (4-5):** โปรเจ็กต์พื้นฐาน
- **Needs Improvement (0-3):** โปรเจ็กต์มีปัญหา

### 2.2 Code Quality (10 คะแนน)
- **Excellent (9-10):** โค้ดสะอาด มี comments, error handling
- **Good (7-8):** โค้ดเข้าใจง่าย ทำงานถูกต้อง
- **Satisfactory (5-6):** โค้ดทำงานได้ตามข้อกำหนด
- **Needs Improvement (0-4):** โค้ดมีปัญหาหรือไม่ทำงาน

### 2.3 Build Process (7 คะแนน)
- **Excellent (7):** Build สำเร็จ มี automation scripts
- **Good (5-6):** Build ได้ปกติ
- **Satisfactory (3-4):** Build ได้บางครั้ง
- **Needs Improvement (0-2):** Build ไม่สำเร็จ

---

## 3. QEMU Simulation (20 คะแนน)

### 3.1 QEMU Setup (8 คะแนน)
- **Excellent (8):** QEMU ติดตั้งและตั้งค่าถูกต้อง
- **Good (6-7):** QEMU ทำงานได้
- **Satisfactory (4-5):** QEMU ทำงานได้บางส่วน
- **Needs Improvement (0-3):** QEMU มีปัญหา

### 3.2 Simulation Results (12 คะแนน)
- **Excellent (11-12):** แสดงผลครบถ้วน, มี logging ที่ดี
- **Good (9-10):** แสดงผลถูกต้อง
- **Satisfactory (6-8):** แสดงผลพื้นฐาน
- **Needs Improvement (0-5):** ไม่แสดงผลหรือผิดพลาด

---

## 4. Debugging with GDB (15 คะแนน)

### 4.1 GDB Connection (6 คะแนน)
- **Excellent (6):** เชื่อมต่อได้เสถียร มีการตั้งค่าที่ดี
- **Good (4-5):** เชื่อมต่อได้ปกติ
- **Satisfactory (2-3):** เชื่อมต่อได้บางครั้ง
- **Needs Improvement (0-1):** เชื่อมต่อไม่ได้

### 4.2 Debugging Skills (9 คะแนน)
- **Excellent (8-9):** ใช้ breakpoints, step, inspect variables ได้
- **Good (6-7):** ใช้คำสั่งพื้นฐานได้
- **Satisfactory (4-5):** ใช้ได้บางคำสั่ง
- **Needs Improvement (0-3):** ใช้ GDB ไม่ได้

---

## 5. Documentation & Report (15 คะแนน)

### 5.1 Technical Report (8 คะแนน)
- **Excellent (8):** รายงานครบถ้วน มีรายละเอียดดี มี analysis
- **Good (6-7):** รายงานดี มีข้อมูลเพียงพอ
- **Satisfactory (4-5):** รายงานพื้นฐาน
- **Needs Improvement (0-3):** รายงานไม่สมบูรณ์

### 5.2 Screenshots & Evidence (4 คะแนน)
- **Excellent (4):** รูปภาพชัดเจน ครบถ้วน มี annotations
- **Good (3):** รูปภาพดี ครบตามข้อกำหนด
- **Satisfactory (2):** รูปภาพพื้นฐาน
- **Needs Improvement (0-1):** รูปภาพไม่ครบหรือไม่ชัด

### 5.3 Video Demonstration (3 คะแนน)
- **Excellent (3):** วิดีโอชัดเจน อธิบายดี แสดงการทำงานครบ
- **Good (2):** วิดีโอดี แสดงการทำงานได้
- **Satisfactory (1):** วิดีโอพื้นฐาน
- **Needs Improvement (0):** ไม่มีวิดีโอหรือไม่ชัด

---

## Bonus Points (สูงสุด 10 คะแนน)

### การปรับปรุงเพิ่มเติม
- **Advanced Features:** การเพิ่มฟีเจอร์เพิ่มเติม (+3-5 คะแนน)
- **Code Optimization:** การปรับปรุง Dockerfile หรือ scripts (+2-3 คะแนน)
- **Creative Solutions:** แนวทางแก้ไขปัญหาที่สร้างสรรค์ (+2-3 คะแนน)
- **Teaching Others:** การช่วยเหลือเพื่อนหรือสร้างคำแนะนำ (+1-2 คะแนน)

---

## Penalty (การหักคะแนน)

### การส่งงานล่าช้า
- **1 วัน:** -10% ของคะแนนรวม
- **2-3 วัน:** -20% ของคะแนนรวม
- **4-7 วัน:** -30% ของคะแนนรวม
- **เกิน 7 วัน:** ไม่รับงาน (0 คะแนน)

### การไม่ปฏิบัติตามข้อกำหนด
- **ไฟล์ไม่ครบ:** -5 คะแนนต่อไฟล์
- **รูปแบบผิด:** -3 คะแนน
- **ขนาดไฟล์เกิน:** -2 คะแนน
- **ไม่ใช้ Pull Request:** -10 คะแนน

---

## Grade Scale

| คะแนน | เกรด | ความหมาย |
|-------|------|-----------|
| 90-100 | A | ยอดเยี่ยม - เข้าใจลึกและประยุกต์ได้ดี |
| 80-89 | B+ | ดีมาก - เข้าใจและทำได้ครบถ้วน |
| 70-79 | B | ดี - เข้าใจพื้นฐานและทำได้ |
| 60-69 | C+ | พอใช้ - ทำได้บางส่วน |
| 50-59 | C | ผ่าน - ทำได้ขั้นพื้นฐาน |
| 0-49 | F | ไม่ผ่าน - ต้องทำใหม่ |

---

## คำแนะนำสำหรับนักศึกษา

### เพื่อให้ได้คะแนนเต็ม:
1. **ทำตามขั้นตอนทั้งหมด** ในใบงานการทดลอง
2. **ทดสอบให้แน่ใจ** ว่าทุกอย่างทำงานได้
3. **เขียนรายงานละเอียด** พร้อมอธิบายปัญหาและการแก้ไข
4. **ถ่ายรูปหน้าจอ** ที่ชัดเจนและครบถ้วน
5. **ทำวิดีโอสาธิต** ที่แสดงการทำงานจริง
6. **ส่งงานตรงเวลา** ตามกำหนด

### หากมีปัญหา:
1. อ่าน troubleshooting guide
2. ถามในกลุ่มหรือฟอรัม
3. ติดต่ออาจารย์หรือ TA
4. ไม่ต้องเก็บปัญหาไว้คนเดียว
