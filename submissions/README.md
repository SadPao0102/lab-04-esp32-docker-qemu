# Submissions Directory

โฟลเดอร์นี้สำหรับเก็บงานของนักศึกษาที่ส่งผ่าน Pull Request

## โครงสร้างการส่งงาน

```
submissions/
├── studentID-name/
│   ├── README.md              # สรุปการทำงาน
│   ├── report.pdf             # รายงานการทดลอง
│   ├── screenshots/           # รูปภาพหน้าจอ
│   │   ├── docker-build.png
│   │   ├── qemu-running.png
│   │   ├── gdb-debug.png
│   │   └── ...
│   ├── code/                  # โค้ดโปรแกรม
│   │   ├── hello_world/
│   │   ├── Dockerfile
│   │   ├── docker-compose.yml
│   │   └── ...
│   └── video_demo.mp4         # วิดีโอสาธิต
└── example-submission/        # ตัวอย่างการส่งงาน
```

## การสร้างโฟลเดอร์ส่วนตัว

1. สร้างโฟลเดอร์ใหม่ด้วยรูปแบบ: `studentID-name`
   - ตัวอย่าง: `65123456-john-doe`

2. คัดลอกไฟล์จาก `example-submission/` มาแก้ไข

3. อัปเดตข้อมูลให้ตรงกับงานของตนเอง

## หมายเหตุ
- ใช้ชื่อไฟล์ภาษาอังกฤษเท่านั้น
- ขนาดไฟล์วิดีโอไม่เกิน 100MB
- รายงานต้องเป็น PDF เท่านั้น
