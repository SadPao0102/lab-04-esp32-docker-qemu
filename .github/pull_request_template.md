# Pull Request Template

## Lab 04 Submission - ESP32 Docker QEMU

**Student Information:**
- Student ID: [รหัสนักศึกษา]
- Name: [ชื่อ-นามสกุล]
- Section: [หมู่เรียน]
- Date: [วันที่ส่งงาน]

## Completion Checklist
กรุณาเช็คถูก (✅) ในส่วนที่ทำเสร็จแล้ว:

### Docker Environment
- [ ] สร้าง Dockerfile สำหรับ ESP32 development
- [ ] ตั้งค่า docker-compose.yml
- [ ] Build Docker image สำเร็จ
- [ ] Container รันได้ปกติ

### ESP32 Development
- [ ] สร้างโปรเจ็กต์ hello_world
- [ ] แก้ไขโค้ดตามที่กำหนด
- [ ] Build โปรแกรมสำเร็จ
- [ ] ไฟล์ binary ถูกสร้างขึ้น

### QEMU Simulation
- [ ] QEMU รันได้
- [ ] แสดงผล Hello World messages
- [ ] Counter เพิ่มขึ้นทุกวินาที
- [ ] Monitor commands ทำงานได้

### Debugging
- [ ] GDB เชื่อมต่อได้
- [ ] ตั้ง breakpoint ได้
- [ ] ดู register และ memory ได้
- [ ] Step through code ได้

### Documentation & Submission
- [ ] รายงานการทดลองฉบับสมบูรณ์
- [ ] Screenshot ครบตามที่กำหนด
- [ ] Video demo (ไม่เกิน 5 นาที)
- [ ] README.md สรุปการทำงาน
- [ ] โค้ดทั้งหมดในโฟลเดอร์ code/

## Summary
[เขียนสรุปสั้นๆ เกี่ยวกับการทำงานและผลลัพธ์ที่ได้]

## Challenges & Solutions
[อธิบายปัญหาที่พบและวิธีการแก้ไข]

## Additional Features (ถ้ามี)
[หากมีการเพิ่มฟีเจอร์หรือปรับปรุงส่วนใดเพิ่มเติม]

## Self Assessment
ประเมินตนเองในแต่ละด้าน (1-10):
- ความสมบูรณ์ของงาน: __/10
- ความเข้าใจเนื้อหา: __/10
- คุณภาพของรายงาน: __/10
- การทำงานตามเวลา: __/10

## Time Spent
- การศึกษาและเตรียมความพร้อม: __ ชั่วโมง
- การติดตั้งและตั้งค่า: __ ชั่วโมง
- การพัฒนาและทดสอบ: __ ชั่วโมง
- การจัดทำเอกสาร: __ ชั่วโมง
- **รวม: __ ชั่วโมง**

## Files Submitted
- [ ] `submissions/[studentID-name]/README.md`
- [ ] `submissions/[studentID-name]/report.pdf`
- [ ] `submissions/[studentID-name]/screenshots/`
- [ ] `submissions/[studentID-name]/code/`
- [ ] `submissions/[studentID-name]/video_demo.mp4`

## Notes
[หมายเหตุเพิ่มเติมหรือข้อความถึงอาจารย์]

---

**Review Guidelines for Instructors:**
- ตรวจสอบความสมบูรณ์ของไฟล์
- ทดสอบการทำงานของ Docker environment
- ประเมินคุณภาพของรายงาน
- ตรวจสอบความเข้าใจผ่านคำถามท้าทาย
