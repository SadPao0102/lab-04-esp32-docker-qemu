# Docker Commands Reference Guide

## คำแนะนำการใช้ Docker และ Docker Compose สำหรับ ESP32 Development

### ภาพรวมของคำสั่งพื้นฐาน

#### 1. การจัดการ Container Lifecycle

```bash
# เริ่มต้น services ทั้งหมดใน background
docker-compose up -d

# เริ่มต้น services และแสดง logs
docker-compose up

# หยุดและลบ containers, networks
docker-compose down

# หยุดและลบ containers, networks, volumes
docker-compose down --volumes

# หยุดและลบ containers, networks, volumes, images
docker-compose down --volumes --rmi all
```

#### 2. การ Execute คำสั่งใน Container

**คำสั่งหลัก: `docker-compose exec`**

**Syntax:**
```bash
docker-compose exec [OPTIONS] SERVICE COMMAND [ARGS...]
```

**ตัวอย่างการใช้งาน:**

```bash
# เข้าสู่ bash shell (พื้นฐาน)
docker-compose exec esp32-dev bash

# เข้าสู่ bash shell พร้อม interactive mode และ TTY
docker-compose exec -it esp32-dev bash

# รันคำสั่งเฉพาะโดยไม่เข้า shell
docker-compose exec esp32-dev idf.py --version

# เข้าสู่ container ในฐานะ root user
docker-compose exec --user root esp32-dev bash

# เข้าสู่ container ที่ working directory เฉพาะ
docker-compose exec --workdir /project/hello_world esp32-dev bash

# รันคำสั่งพร้อมตั้งค่า environment variables
docker-compose exec -e DEBUG=1 -e VERBOSE=1 esp32-dev idf.py build
```

### พารามิเตอร์สำคัญของ docker-compose exec

#### ตัวเลือกการรัน (Execution Options)
- **`-i, --interactive`**: เปิด STDIN แม้ว่าจะไม่ได้ attach
- **`-t, --tty`**: จัดสรร pseudo-TTY
- **`-d, --detach`**: รันใน background (detached mode)

#### ตัวเลือกผู้ใช้และสิทธิ์ (User & Privileges)
- **`--user USER`**: กำหนด username หรือ UID ที่ใช้รันคำสั่ง
- **`--privileged`**: ให้สิทธิ์พิเศษแก่ container

#### ตัวเลือกสภาพแวดล้อม (Environment)
- **`-e, --env KEY=VAL`**: ตั้งค่า environment variables
- **`--workdir DIR`**: กำหนด working directory

#### ตัวเลือกอื่นๆ
- **`--index=INDEX`**: เลือก container instance เฉพาะ (สำหรับ scaled services)

### ตัวอย่างการใช้งานจริง

#### การพัฒนาโปรแกรม ESP32

```bash
# 1. เริ่มต้น development environment
docker-compose up -d

# 2. เข้าสู่ container
docker-compose exec esp32-dev bash

# 3. สร้างโปรเจ็กต์ใหม่
docker-compose exec esp32-dev idf.py create-project my_project

# 4. Build โปรเจ็กต์
docker-compose exec esp32-dev idf.py build

# 5. รัน QEMU simulation
docker-compose exec esp32-dev qemu-system-xtensa -machine esp32 -kernel build/my_project.elf

# 6. Debug ด้วย GDB
docker-compose exec esp32-dev xtensa-esp32-elf-gdb build/my_project.elf
```

#### การแก้ไขปัญหา Permission

```bash
# ตรวจสอบ user ID ปัจจุบัน
docker-compose exec esp32-dev id

# เข้าสู่ container ในฐานะ root
docker-compose exec --user root esp32-dev bash

# แก้ไข ownership ของไฟล์
docker-compose exec --user root esp32-dev chown -R 1000:1000 /project

# สร้างไฟล์ด้วย user เฉพาะ
docker-compose exec --user 1000:1000 esp32-dev touch /project/test.txt
```

#### การทำงานกับ Multiple Containers

```bash
# ดูสถานะ containers ทั้งหมด
docker-compose ps

# เข้าสู่ container เฉพาะ
docker-compose exec esp32-dev bash
docker-compose exec database bash

# รันคำสั่งใน container เฉพาะ
docker-compose exec esp32-dev idf.py build
docker-compose exec database mysql -u root -p
```

### การจัดการ Environment Variables

```bash
# ตั้งค่า environment variable เดียว
docker-compose exec -e IDF_TARGET=esp32s3 esp32-dev idf.py set-target esp32s3

# ตั้งค่า environment variables หลายตัว
docker-compose exec -e DEBUG=1 -e VERBOSE=1 -e LOG_LEVEL=info esp32-dev idf.py build

# ใช้ environment variables จากไฟล์
docker-compose exec --env-file .env esp32-dev idf.py build
```

### การทำงานกับ Files และ Directories

```bash
# เข้าสู่ directory เฉพาะ
docker-compose exec --workdir /project/src esp32-dev bash

# คัดลอกไฟล์เข้า container
docker cp local_file.txt container_name:/project/

# คัดลอกไฟล์ออกจาก container
docker cp container_name:/project/build/app.bin ./output/

# ดูขนาดไฟล์ใน container
docker-compose exec esp32-dev du -sh /project/*
```

### การ Debug และ Monitor

```bash
# ดู logs ของ container
docker-compose logs esp32-dev

# ดู logs แบบ real-time
docker-compose logs -f esp32-dev

# ดู processes ที่รันใน container
docker-compose exec esp32-dev ps aux

# ดู resource usage
docker-compose exec esp32-dev top

# ตรวจสอบ network connectivity
docker-compose exec esp32-dev ping google.com
```

### Best Practices

#### 1. การใช้ Interactive Mode

```bash
# ✅ ถูกต้อง - ใช้สำหรับ interactive sessions
docker-compose exec -it esp32-dev bash

# ❌ ไม่แนะนำ - อาจมีปัญหากับ terminal
docker-compose exec esp32-dev bash
```

#### 2. การจัดการ User Permissions

```bash
# ✅ ใช้ user ID ที่ตรงกับ host system
docker-compose exec --user $(id -u):$(id -g) esp32-dev bash

# ✅ หรือกำหนดใน docker-compose.yml
# user: "${UID:-1000}:${GID:-1000}"
```

#### 3. การตั้งค่า Working Directory

```bash
# ✅ กำหนด working directory ให้ชัดเจน
docker-compose exec --workdir /project/hello_world esp32-dev idf.py build

# ✅ หรือใช้ relative path
docker-compose exec esp32-dev bash -c "cd hello_world && idf.py build"
```

### Error Handling และ Exit Codes

```bash
# ตรวจสอบ exit code ของคำสั่ง
docker-compose exec esp32-dev idf.py build
echo "Exit code: $?"

# รันคำสั่งแล้วจัดการ error
if docker-compose exec esp32-dev idf.py build; then
    echo "Build successful"
else
    echo "Build failed"
    docker-compose logs esp32-dev
fi
```

### คำสั่งเพิ่มเติมที่มีประโยชน์

```bash
# ตรวจสอบว่า container รันอยู่หรือไม่
docker-compose exec esp32-dev echo "Container is running"

# รันคำสั่งที่ใช้เวลานาน
docker-compose exec esp32-dev bash -c "
    echo 'Starting long running task...'
    sleep 10
    echo 'Task completed'
"

# รันคำสั่งหลายบรรทัด
docker-compose exec esp32-dev bash -c '
    cd /project
    idf.py clean
    idf.py build
    echo "Build completed"
'
```

### การแก้ไขปัญหาทั่วไป

#### ปัญหา: "No such service"
```bash
# ตรวจสอบชื่อ service ใน docker-compose.yml
docker-compose config --services

# ตรวจสอบว่า services รันอยู่
docker-compose ps
```

#### ปัญหา: "Container not running"
```bash
# เริ่ม services
docker-compose up -d

# ตรวจสอบสาเหตุที่ container ไม่รัน
docker-compose logs esp32-dev
```

#### ปัญหา: Permission denied
```bash
# เข้าในฐานะ root แล้วแก้ไข permissions
docker-compose exec --user root esp32-dev chown -R $(id -u):$(id -g) /project
```

การเข้าใจและใช้คำสั่ง `docker-compose exec` อย่างถูกต้องจะช่วยให้การพัฒนาโปรแกรม ESP32 ใน Docker environment เป็นไปอย่างราบรื่นและมีประสิทธิภาพ
