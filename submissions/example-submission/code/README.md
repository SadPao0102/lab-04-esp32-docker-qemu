# Code Directory

โฟลเดอร์นี้สำหรับเก็บโค้ดโปรแกรมทั้งหมดที่ใช้ในการทดลอง

## โครงสร้างที่แนะนำ:

```
code/
├── hello_world/              # โปรเจ็กต์ ESP32
│   ├── main/
│   │   ├── hello_world_main.c
│   │   └── CMakeLists.txt
│   ├── CMakeLists.txt
│   └── sdkconfig
├── Dockerfile                # Docker configuration
├── docker-compose.yml        # Docker services
├── Makefile                  # Build automation
├── esp32-helper.sh          # Helper scripts
├── run_qemu.sh              # QEMU script
└── README.md                # คำอธิบายโค้ด
```

## คำแนะนำ:
1. คัดลอกไฟล์จากโปรเจ็กต์หลัก
2. ตรวจสอบว่าไฟล์ทำงานได้จริง
3. เพิ่มคำอธิบายในส่วนที่สำคัญ
4. รวมไฟล์ configuration ที่จำเป็น

## ไฟล์ที่ต้องมี:
- ✅ Dockerfile
- ✅ docker-compose.yml  
- ✅ hello_world project
- ✅ Helper scripts
- ✅ Documentation
