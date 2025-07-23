# ใบงานการทดลองที่ 4: การใช้ Docker สำหรับพัฒนา ESP32 และจำลองด้วย QEMU

## วัตถุประสงค์
1. สามารถอธิบายการสร้างและใช้งาน Docker container สำหรับการพัฒนาโปรแกรม ESP32 
2. สร้างสภาพแวดล้อมการพัฒนาที่สามารถใช้งานได้บนระบบปฏิบัติการต่าง ๆ
3. สามารถใช้ QEMU ในการจำลองการทำงานของ ESP32
4. ปฏิบัติการสร้างโปรแกรมตัวอย่างและทดสอบการทำงาน

## เครื่องมือที่ต้องใช้
- Docker Desktop
- Text Editor (VS Code แนะนำ)
- Terminal/Command Prompt (ผ่าน VS Code)
- Internet connection สำหรับดาวน์โหลด Docker images

## การเตรียมความพร้อม

### ขั้นตอนที่ 1: ตรวจสอบการติดตั้ง Docker
```bash
docker --version
docker-compose --version
```

**ผลลัพธ์ที่คาดหวัง:**
```
Docker version 24.x.x, build xxxxxxx
Docker Compose version v2.x.x
```

**การทดสอบ:** หากคำสั่งไม่ทำงาน ให้ติดตั้ง Docker Desktop จาก https://www.docker.com/products/docker-desktop

---

## ส่วนที่ 1: การสร้าง Docker Environment สำหรับ ESP32

### ขั้นตอนที่ 2: สร้างโครงสร้างโปรเจ็กต์
```bash
mkdir esp32-docker-project
cd esp32-docker-project
mkdir src
mkdir build
```

**การทดสอบ:** ใช้คำสั่ง `dir` (Windows) หรือ `ls -la` (Linux/Mac) เพื่อตรวจสอบโครงสร้างโฟลเดอร์

### ขั้นตอนที่ 3: สร้าง Dockerfile สำหรับ ESP32
สร้างไฟล์ `Dockerfile` ด้วยเนื้อหาดังนี้:

```dockerfile
FROM espressif/idf:v5.1

# Install additional tools
RUN apt-get update && apt-get install -y \
    git \
    wget \
    flex \
    bison \
    gperf \
    python3 \
    python3-pip \
    python3-setuptools \
    cmake \
    ninja-build \
    ccache \
    libffi-dev \
    libssl-dev \
    dfu-util \
    libusb-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install QEMU for ESP32 simulation
RUN apt-get update && apt-get install -y \
    qemu-system-xtensa \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /project

# Copy project files
COPY . /project

# Set environment variables
ENV IDF_PATH=/opt/esp/idf
ENV PATH="${IDF_PATH}/tools:${PATH}"

# Default command
CMD ["bash"]
```

**การทดสอบ:** ตรวจสอบว่าไฟล์ Dockerfile ถูกสร้างขึ้นและมีเนื้อหาถูกต้อง

### ขั้นตอนที่ 4: สร้าง docker-compose.yml
สร้างไฟล์ `docker-compose.yml` โดยมีเนื้อหาดังต่อไปนี้

```yaml
version: '3.8'

services:
  esp32-dev:
    build: .
    container_name: esp32-development
    volumes:
      - ./src:/project/src
      - ./build:/project/build
      - ./components:/project/components
    working_dir: /project
    stdin_open: true
    tty: true
    privileged: true
    devices:
      - /dev:/dev
    environment:
      - IDF_PATH=/opt/esp/idf
    networks:
      - esp32-network

networks:
  esp32-network:
    driver: bridge
```

**การทดสอบ:** ตรวจสอบไฟล์ด้วยคำสั่ง `docker-compose config` เพื่อยืนยันว่า syntax ถูกต้อง

### ขั้นตอนที่ 5: Build Docker Image
```bash
docker-compose build
```

**ผลลัพธ์ที่คาดหวัง:** กระบวนการ build สำเร็จโดยไม่มี error

**การทดสอบ:** ตรวจสอบ image ที่สร้างขึ้น:
```bash
docker images
```

---

## ส่วนที่ 2: การสร้างโปรแกรมตัวอย่าง ESP32

### ขั้นตอนที่ 6: เริ่มต้น Container
```bash
docker-compose up -d
docker-compose exec esp32-dev bash
```

**อธิบายคำสั่ง:**

**`docker-compose up -d`**
- `up`: เริ่มต้น services ที่กำหนดใน docker-compose.yml
- `-d` (detached): รันใน background โดยไม่ล็อค terminal

**`docker-compose exec esp32-dev bash`**
- `exec`: เรียกใช้คำสั่งใน container ที่กำลังรันอยู่
- `esp32-dev`: ชื่อ service ที่กำหนดใน docker-compose.yml
- `bash`: เรียกใช้ bash shell เพื่อเข้าสู่ interactive mode

**ตัวเลือกเพิ่มเติมที่อาจใช้:**
```bash
# เข้าสู่ container พร้อม TTY และ interactive mode
docker-compose exec -it esp32-dev bash

# เข้าสู่ container ในฐานะ root user
docker-compose exec --user root esp32-dev bash

# เข้าสู่ container ที่ working directory ที่กำหนด
docker-compose exec --workdir /project/hello_world esp32-dev bash

# เรียกใช้คำสั่งเฉพาะแทนที่จะเปิด shell
docker-compose exec esp32-dev idf.py --version
```

**การทดสอบ:** ตรวจสอบว่าเข้าสู่ container สำเร็จโดยดูจาก prompt ที่เปลี่ยนไป เช่น:
```
root@container-id:/project#
```

### ขั้นตอนที่ 7: สร้างโปรเจ็กต์ ESP32 ตัวอย่าง
ภายใน container ให้รันคำสั่ง:

```bash
cd /project
idf.py create-project hello_world
cd hello_world
```

**การทดสอบ:** ตรวจสอบว่าโฟลเดอร์โปรเจ็กต์ถูกสร้างขึ้น:
```bash
ls -la
```

### ขั้นตอนที่ 8: แก้ไขโปรแกรมตัวอย่าง
แก้ไขไฟล์ `main/hello_world_main.c`:

```c
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h"
#include "esp_log.h"

static const char *TAG = "HELLO_WORLD";

void app_main(void)
{
    int counter = 0;
    
    ESP_LOGI(TAG, "ESP32 Docker QEMU Demo Starting...");
    
    while (1) {
        ESP_LOGI(TAG, "Hello World! Counter: %d", counter++);
        
        if (counter % 10 == 0) {
            ESP_LOGI(TAG, "System uptime: %d seconds", (int)(esp_timer_get_time() / 1000000));
        }
        
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
```

**การทดสอบ:** ตรวจสอบว่าไฟล์ถูกแก้ไขถูกต้อง:
```bash
cat main/hello_world_main.c
```

### ขั้นตอนที่ 9: กำหนดการตั้งค่าโปรเจ็กต์
```bash
idf.py set-target esp32
idf.py menuconfig
```

**การทดสอบ:** เมนูการตั้งค่าควรเปิดขึ้นมา สามารถออกได้โดยกด Q และ Y

### ขั้นตอนที่ 10: Build โปรแกรม
```bash
idf.py build
```

**ผลลัพธ์ที่คาดหวัง:** การ build สำเร็จและได้ไฟล์ binary

**การทดสอบ:** ตรวจสอบไฟล์ที่ build ได้:
```bash
ls -la build/
```

---

## ส่วนที่ 3: การจำลองด้วย QEMU

### ขั้นตอนที่ 11: เตรียม QEMU สำหรับ ESP32
```bash
# ตรวจสอบการติดตั้ง QEMU
qemu-system-xtensa --version

# สร้างโฟลเดอร์สำหรับ QEMU
mkdir -p qemu_simulation
```

**การทดสอบ:** ควรเห็นเวอร์ชันของ QEMU แสดงขึ้นมา

### ขั้นตอนที่ 12: สร้างสคริปต์สำหรับรัน QEMU
สร้างไฟล์ `run_qemu.sh`:

```bash
#!/bin/bash

QEMU_ESP32_PATH="/opt/esp/idf/tools/qemu-esp32"
BINARY_PATH="build/hello_world.bin"
ELF_PATH="build/hello_world.elf"

echo "Starting ESP32 QEMU Simulation..."

qemu-system-xtensa \
    -machine esp32 \
    -cpu esp32 \
    -m 4M \
    -nographic \
    -kernel ${ELF_PATH} \
    -s -S \
    -monitor stdio
```

**การทดสอบ:** ให้ไฟล์สามารถรันได้:
```bash
chmod +x run_qemu.sh
```

### ขั้นตอนที่ 13: รันการจำลองด้วย QEMU
```bash
./run_qemu.sh
```

**ผลลัพธ์ที่คาดหวัง:** QEMU จะเริ่มต้นและรอการเชื่อมต่อ debugger

**การทดสอบ:** ใน terminal อื่น สามารถเชื่อมต่อด้วย GDB:
```bash
xtensa-esp32-elf-gdb build/hello_world.elf
```

### ขั้นตอนที่ 14: การใช้งาน Monitor Commands
ใน QEMU monitor สามารถใช้คำสั่ง:

```
(qemu) info registers    # ดูสถานะ registers
(qemu) info memory       # ดูการใช้งาน memory  
(qemu) cont              # เริ่มการทำงาน
(qemu) stop              # หยุดการทำงาน
(qemu) quit              # ออกจาก QEMU
```

**การทดสอบ:** ทดลองใช้คำสั่งต่างๆ และสังเกตผลลัพธ์

---

## ส่วนที่ 4: การทดสอบและ Debug

### ขั้นตอนที่ 15: การ Debug ด้วย GDB
เปิด terminal ใหม่และรันคำสั่ง:

```bash
docker-compose exec esp32-dev bash
cd /project/hello_world
xtensa-esp32-elf-gdb build/hello_world.elf

# ใน GDB prompt
(gdb) target remote :1234
(gdb) break app_main
(gdb) continue
```

**การทดสอบ:** โปรแกรมควรหยุดที่ breakpoint ใน function app_main

### ขั้นตอนที่ 16: การตรวจสอบ Log Output
สำหรับดู log output สามารถใช้:

```bash
# รัน QEMU โดยไม่ใช้ monitor mode
qemu-system-xtensa \
    -machine esp32 \
    -cpu esp32 \
    -m 4M \
    -nographic \
    -kernel build/hello_world.elf
```

**ผลลัพธ์ที่คาดหวัง:** จะเห็น log message จากโปรแกรม hello_world

**การทดสอบ:** สังเกต counter ที่เพิ่มขึ้นทุกวินาที

---

## ส่วนที่ 5: การจัดการ Environment

### ขั้นตอนที่ 17: การสร้าง Makefile สำหรับงานประจำ
สร้างไฟล์ `Makefile`:

```makefile
.PHONY: build clean run-qemu debug stop

build:
	docker-compose exec esp32-dev idf.py build

clean:
	docker-compose exec esp32-dev idf.py clean

run-qemu:
	docker-compose exec esp32-dev qemu-system-xtensa \
		-machine esp32 \
		-cpu esp32 \
		-m 4M \
		-nographic \
		-kernel build/hello_world.elf

debug:
	docker-compose exec esp32-dev xtensa-esp32-elf-gdb build/hello_world.elf

stop:
	docker-compose down

start:
	docker-compose up -d

shell:
	docker-compose exec esp32-dev bash
```

**การทดสอบ:** ทดลองใช้คำสั่ง `make build` และสังเกตผลลัพธ์

### ขั้นตอนที่ 18: การสร้างสคริปต์ Helper
สร้างไฟล์ `esp32-helper.sh`:

```bash
#!/bin/bash

case "$1" in
    "start")
        echo "Starting ESP32 development environment..."
        docker-compose up -d
        ;;
    "stop")
        echo "Stopping ESP32 development environment..."
        docker-compose down
        ;;
    "shell")
        echo "Opening shell in ESP32 container..."
        docker-compose exec esp32-dev bash
        ;;
    "build")
        echo "Building ESP32 project..."
        docker-compose exec esp32-dev idf.py build
        ;;
    "qemu")
        echo "Starting QEMU simulation..."
        docker-compose exec esp32-dev ./run_qemu.sh
        ;;
    *)
        echo "Usage: $0 {start|stop|shell|build|qemu}"
        exit 1
        ;;
esac
```

**การทดสอบ:** ให้สิทธิ์และทดลองใช้:
```bash
chmod +x esp32-helper.sh
./esp32-helper.sh start
```

---

## การทดสอบขั้นสุดท้าย

### ขั้นตอนที่ 19: การทดสอบแบบครบวงจร
1. **เริ่มต้น environment:**
```bash
./esp32-helper.sh start
```

2. **Build โปรแกรม:**
```bash
./esp32-helper.sh build
```

3. **รันการจำลอง:**
```bash
./esp32-helper.sh qemu
```

4. **ทดสอบการ debug:**
```bash
./esp32-helper.sh shell
# ใน container
xtensa-esp32-elf-gdb build/hello_world.elf
```

**ผลลัพธ์ที่คาดหวัง:** ทุกขั้นตอนทำงานได้ปกติไม่มี error

### ขั้นตอนที่ 20: การทำความสะอาด
```bash
./esp32-helper.sh stop
docker-compose down --volumes
docker system prune
```

**การทดสอบ:** ตรวจสอบว่า container และ volume ถูกลบแล้ว:
```bash
docker ps -a
docker volume ls
```

---

## รายงานผลการทดลอง

### ส่วนที่ต้องรายงาน:
1. **Screenshot การ build Docker image สำเร็จ**
2. **Screenshot ผลลัพธ์การรัน hello_world บน QEMU**
3. **Screenshot การใช้งาน GDB เพื่อ debug**
4. **รายชื่อไฟล์ที่สร้างขึ้นในโปรเจ็กต์**
5. **ปัญหาที่พบและแนวทางแก้ไข**

### คำถามท้าทาย:
1. เปรียบเทียบข้อดี-ข้อเสียของการใช้ Docker vs การติดตั้ง ESP-IDF บนเครื่องโดยตรง
2. อธิบายประโยชน์ของการใช้ QEMU ในการพัฒนา embedded system
3. แนะนำวิธีการปรับปรุง Dockerfile เพื่อให้มีประสิทธิภาพมากขึ้น

### การส่งงาน:
นักศึกษาต้องส่งงานผ่าน **Pull Request** โดยมีขั้นตอนดังนี้:

#### ขั้นตอนการส่งงาน:

1. **Fork Repository หลัก**
   - ไปที่ GitHub repository ของโครงการ
   - คลิก "Fork" เพื่อสร้าง copy ในบัญชีของตนเอง

2. **Clone และทำงาน**
   ```bash
   git clone https://github.com/YOUR_USERNAME/lab-04-esp32-docker-qemu.git
   cd lab-04-esp32-docker-qemu
   ```

3. **สร้าง Branch สำหรับงาน**
   ```bash
   git checkout -b submission/studentID-name
   # ตัวอย่าง: git checkout -b submission/65123456-john-doe
   ```

4. **เพิ่มงานที่ทำ**
   - สร้างโฟลเดอร์ `submissions/studentID-name/`
   - ใส่ไฟล์งานทั้งหมดในโฟลเดอร์นี้

5. **ไฟล์ที่ต้องส่ง:**
   - `report.pdf` - รายงานการทดลองฉบับสมบูรณ์
   - `screenshots/` - โฟลเดอร์รวม screenshot ทั้งหมด
   - `code/` - โค้ดโปรแกรมที่สร้างขึ้น
   - `video_demo.mp4` - วิดีโอ demo (ไม่เกิน 5 นาที)
   - `README.md` - สรุปการทำงานและปัญหาที่พบ

6. **Commit และ Push**
   ```bash
   git add .
   git commit -m "Add lab submission for [StudentID] - [Name]"
   git push origin submission/studentID-name
   ```

7. **สร้าง Pull Request**
   - กลับไปที่ GitHub repository ของตนเอง
   - คลิก "Compare & pull request"
   - เขียน title: `Lab Submission - [StudentID] [Name]`
   - เขียน description ตามแบบฟอร์มที่กำหนด

#### แบบฟอร์ม Pull Request:
```markdown
## Lab 04 Submission - ESP32 Docker QEMU

**Student Information:**
- Student ID: [รหัสนักศึกษา]
- Name: [ชื่อ-นามสกุล]

**Completion Status:**
- [ ] Docker Environment Setup
- [ ] ESP32 Project Creation
- [ ] QEMU Simulation
- [ ] GDB Debugging
- [ ] Report Documentation
- [ ] Video Demo

**Summary:**
[สรุปสั้นๆ เกี่ยวกับการทำงานและผลลัพธ์]

**Challenges & Solutions:**
[ปัญหาที่พบและวิธีแก้ไข]

**Additional Notes:**
[หมายเหตุเพิ่มเติม]
```

#### กำหนดส่ง:
- **Deadline:** [วันที่กำหนดส่ง] 23:59 น.
- **Late Submission:** หักคะแนน 10% ต่อวัน
- **ไม่รับงานหลังเกิน 7 วัน**

---

## ภาคผนวก

### คำสั่งที่มีประโยชน์:

**Docker Commands:**
```bash
docker ps                    # ดู container ที่ทำงานอยู่
docker images               # ดู images ทั้งหมด
docker logs <container>     # ดู logs ของ container
docker exec -it <container> bash  # เข้าสู่ container
```

**Docker Compose Commands (อธิบายเพิ่มเติม):**
```bash
# การจัดการ services
docker-compose up -d              # เริ่ม services ใน background
docker-compose down               # หยุดและลบ containers
docker-compose stop               # หยุด services (ไม่ลบ containers)
docker-compose start              # เริ่ม services ที่หยุดไว้
docker-compose restart            # รีสตาร์ท services

# การดูข้อมูล
docker-compose ps                 # ดูสถานะ services
docker-compose logs esp32-dev     # ดู logs ของ service
docker-compose top esp32-dev      # ดู processes ที่ทำงานใน container

# การ execute คำสั่ง
docker-compose exec esp32-dev bash           # เข้าสู่ bash shell
docker-compose exec -it esp32-dev bash       # เข้าสู่ interactive bash
docker-compose exec --user root esp32-dev bash  # เข้าในฐานะ root
docker-compose exec esp32-dev idf.py --version   # รันคำสั่งเฉพาะ

# การจัดการ volumes และ networks
docker-compose down --volumes     # ลบ containers และ volumes
docker-compose down --rmi all     # ลบ containers และ images
```

**พารามิเตอร์สำคัญของ docker-compose exec:**
- `-i, --interactive`: เปิด interactive mode
- `-t, --tty`: จัดสรร pseudo-TTY
- `--user`: กำหนด user ที่ใช้รันคำสั่ง
- `--workdir`: กำหนด working directory
- `-e, --env`: ตั้งค่า environment variables
- `--privileged`: รันด้วย privileged mode

**ตัวอย่างการใช้งาน:**
```bash
# เข้าสู่ container และไปที่โฟลเดอร์เฉพาะ
docker-compose exec --workdir /project/hello_world esp32-dev bash

# รันคำสั่งพร้อมตั้งค่า environment variable
docker-compose exec -e DEBUG=1 esp32-dev idf.py build

# เข้าสู่ container ในฐานะ user เฉพาะ
docker-compose exec --user 1000:1000 esp32-dev bash
```

**ESP-IDF Commands:**
```bash
idf.py menuconfig          # เปิดการตั้งค่า
idf.py build              # build โปรเจ็กต์
idf.py clean              # ลบไฟล์ build
idf.py monitor            # ดู serial output
```

**QEMU Commands:**
```bash
info registers            # ดู registers
info memory               # ดู memory
cont                      # เริ่มต้น/ต่อการทำงาน
stop                      # หยุดการทำงาน
quit                      # ออกจาก QEMU
```

### Troubleshooting:

**ปัญหา: Docker build ล้มเหลว**
- ตรวจสอบ internet connection
- ลบ cache: `docker system prune -a`
- ตรวจสอบ disk space

**ปัญหา: docker-compose exec ไม่ทำงาน**
- **สาเหตุ:** Container ไม่ได้รันอยู่
- **วิธีแก้:** 
  ```bash
  docker-compose ps  # ตรวจสอบสถานะ
  docker-compose up -d  # เริ่ม container
  ```

**ปัญหา: Permission denied ใน container**
- **สาเหตุ:** User permissions ไม่ถูกต้อง
- **วิธีแก้:**
  ```bash
  # เข้าในฐานะ root แล้วแก้ไข permissions
  docker-compose exec --user root esp32-dev bash
  chown -R $(id -u):$(id -g) /project
  ```

**ปัญหา: TTY หรือ Terminal ไม่ทำงาน**
- **สาเหตุ:** ไม่ได้ใช้ flags ที่เหมาะสม
- **วิธีแก้:**
  ```bash
  # ใช้ -it flags สำหรับ interactive terminal
  docker-compose exec -it esp32-dev bash
  ```

**ปัญหา: Container ออกทันที**
- **สาเหตุ:** Service ไม่ได้ตั้งค่าให้รันแบบ persistent
- **วิธีแก้:** ตรวจสอบ docker-compose.yml ว่ามี `tty: true` และ `stdin_open: true`

**ปัญหา: QEMU ไม่ทำงาน**
- ตรวจสอบว่า build สำเร็จแล้ว
- ตรวจสอบ path ของไฟล์ binary
- ลองใช้ `-nographic` flag

**ปัญหา: GDB เชื่อมต่อไม่ได้**
- ตรวจสอบว่า QEMU รันอยู่
- ใช้ port 1234 (default)
- ตรวจสอบ firewall settings

**คำสั่งแก้ไขปัญหาเบื้องต้น:**
```bash
# รีสตาร์ท Docker environment
docker-compose down
docker-compose up -d

# ตรวจสอบ logs หาปัญหา
docker-compose logs esp32-dev

# ทำความสะอาดระบบ Docker
docker system prune -f

# ลบและสร้าง containers ใหม่
docker-compose down --volumes
docker-compose build --no-cache
docker-compose up -d
```
