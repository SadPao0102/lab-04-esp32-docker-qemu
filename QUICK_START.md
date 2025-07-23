# ขั้นตอนการเริ่มต้นใช้งาน ESP32 Docker QEMU Lab

## การเตรียมความพร้อมเบื้องต้น

### 1. ตรวจสอบระบบ
```bash
# ตรวจสอบ Docker
docker --version
docker-compose --version

# ตรวจสอบพื้นที่ดิสก์ (ต้องมีอย่างน้อย 5GB)
dir
```

### 2. Clone หรือ Download โปรเจ็กต์
```bash
# หากใช้ Git
git clone <repository-url>
cd lab-04-esp32-docker-qemu

# หรือ Download และแตกไฟล์
cd lab-04-esp32-docker-qemu
```

### 3. ขั้นตอนการเริ่มต้น
```bash
# 1. Build Docker image (ครั้งแรกใช้เวลานาน 10-15 นาที)
docker-compose build

# 2. เริ่มต้น container
docker-compose up -d

# 3. เข้าสู่ container
docker-compose exec esp32-dev bash
```

### 4. สร้างโปรเจ็กต์ตัวอย่าง
```bash
# ภายใน container
cd /project
idf.py create-project hello_world
cd hello_world

# คัดลอกโค้ดตัวอย่าง
cp /project/examples/hello_world_main.c main/hello_world_main.c

# ตั้งค่า target
idf.py set-target esp32

# Build โปรแกรม
idf.py build
```

### 5. ทดสอบด้วย QEMU
```bash
# รันการจำลอง
qemu-system-xtensa \
    -machine esp32 \
    -cpu esp32 \
    -m 4M \
    -nographic \
    -kernel build/hello_world.elf
```

## การใช้งานสคริปต์ Helper

```bash
# ให้สิทธิ์สคริปต์
chmod +x esp32-helper.sh

# เริ่มต้น environment
./esp32-helper.sh start

# เข้าสู่ shell
./esp32-helper.sh shell

# Build โปรแกรม
./esp32-helper.sh build

# รัน QEMU
./esp32-helper.sh qemu

# หยุดการทำงาน
./esp32-helper.sh stop
```

## การแก้ไขปัญหาเบื้องต้น

### ปัญหา Docker
```bash
# หยุดและลบ container
docker-compose down

# ลบ image และสร้างใหม่
docker rmi $(docker images -q)
docker-compose build --no-cache
```

### ปัญหา Permission (Linux/Mac)
```bash
sudo chmod +x esp32-helper.sh
sudo chmod +x run_qemu.sh
```

### ปัญหา QEMU
```bash
# ตรวจสอบว่าไฟล์ binary มีอยู่
ls -la build/hello_world.elf

# หากไม่มีให้ build ใหม่
idf.py clean
idf.py build
```
