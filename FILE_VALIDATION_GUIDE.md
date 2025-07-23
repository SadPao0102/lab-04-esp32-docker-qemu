# File Validation Guide - ESP32 Docker Project

## คำแนะนำการตรวจสอบไฟล์ในโปรเจ็กต์

### ภาพรวม
การตรวจสอบไฟล์ให้ถูกต้องเป็นขั้นตอนสำคัญที่ช่วยป้องกันปัญหาในการ build และรัน Docker container

---

## 1. การตรวจสอบ Dockerfile

### 1.1 การตรวจสอบพื้นฐาน

**คำสั่งตรวจสอบ:**
```bash
# Windows Command Prompt
dir Dockerfile
type Dockerfile

# PowerShell
Get-Content Dockerfile
Test-Path Dockerfile

# Linux/Mac
ls -la Dockerfile
cat Dockerfile
file Dockerfile
```

**สิ่งที่ต้องตรวจสอบ:**
- ไฟล์มีอยู่และมีขนาด > 0 bytes
- ไม่มีการเข้ารหัสแปลกๆ (BOM, special characters)
- Line endings ถูกต้อง (LF หรือ CRLF)

### 1.2 การตรวจสอบเนื้อหา

**โครงสร้างที่ต้องมี:**
```dockerfile
FROM espressif/idf:v5.1          # Base image ถูกต้อง

# RUN commands สำหรับ package installation
RUN apt-get update && apt-get install -y \
    git \
    wget \
    # ... other packages

# QEMU installation
RUN apt-get update && apt-get install -y \
    qemu-system-xtensa \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /project

# File copying
COPY . /project

# Environment variables
ENV IDF_PATH=/opt/esp/idf
ENV PATH="${IDF_PATH}/tools:${PATH}"

# Default command
CMD ["bash"]
```

**การตรวจสอบ syntax:**
```bash
# ตรวจสอบ Dockerfile syntax
docker build --no-cache --dry-run .

# หรือใช้ linter (ถ้าติดตั้งแล้ว)
hadolint Dockerfile
```

### 1.3 ปัญหาที่พบบ่อย

| ปัญหา | สาเหตุ | วิธีแก้ |
|-------|--------|---------|
| `unknown instruction` | คำสั่ง Docker ผิด | ตรวจสอบ spelling และ syntax |
| `COPY failed` | ไฟล์ไม่พบ | ตรวจสอบ path และการมีอยู่ของไฟล์ |
| `Package not found` | Repository ไม่อัปเดต | เพิ่ม `apt-get update` |
| `Permission denied` | User permissions | ใช้ `RUN chmod` หรือ `USER` |

---

## 2. การตรวจสอบ docker-compose.yml

### 2.1 การตรวจสอบ YAML Syntax

**คำสั่งตรวจสอบ:**
```bash
# ตรวจสอบ syntax และแสดง configuration
docker-compose config

# ตรวจสอบเฉพาะ services
docker-compose config --services

# ตรวจสอบ volumes
docker-compose config --volumes

# Validate โดยไม่แสดงผล
docker-compose config --quiet
```

**Online YAML Validators:**
- yamllint.com
- jsonformatter.org/yaml-validator

### 2.2 โครงสร้างที่ถูกต้อง

```yaml
version: '3.8'                    # Version ที่รองรับ

services:
  esp32-dev:                      # Service name
    build: .                      # Build context
    container_name: esp32-development
    volumes:                      # Volume mappings
      - ./src:/project/src
      - ./build:/project/build
      - ./components:/project/components
    working_dir: /project         # Working directory
    stdin_open: true              # Keep STDIN open
    tty: true                     # Allocate TTY
    privileged: true              # Required for device access
    devices:                      # Device mappings
      - /dev:/dev
    environment:                  # Environment variables
      - IDF_PATH=/opt/esp/idf
    networks:                     # Networks
      - esp32-network

networks:
  esp32-network:
    driver: bridge
```

### 2.3 การตรวจสอบรายละเอียด

**ตรวจสอบ indentation:**
```bash
# YAML ต้องใช้ spaces ไม่ใช่ tabs
# ใช้ 2 spaces สำหรับแต่ละระดับ

# ตรวจสอบ tabs ใน file (Linux/Mac)
cat -A docker-compose.yml | grep '\t'

# ถ้าพบ ^I แสดงว่ามี tab characters
```

**ตรวจสอบ environment variables:**
```bash
# แสดง environment ที่จะถูกตั้งค่า
docker-compose config | grep -A 10 environment
```

### 2.4 ปัญหาที่พบบ่อย

| ปัญหา | สาเหตุ | วิธีแก้ |
|-------|--------|---------|
| `yaml: line X: found character that cannot start any token` | Indentation ผิด | ใช้ spaces แทน tabs |
| `Service 'xxx' uses an undefined network` | Network ไม่ได้ define | เพิ่ม network ในส่วน networks |
| `Invalid compose file` | Syntax ผิด | ใช้ `docker-compose config` ตรวจสอบ |
| `Mount denied` | Path ไม่ถูกต้อง | ตรวจสอบ absolute/relative paths |

---

## 3. การตรวจสอบไฟล์อื่นๆ

### 3.1 สคริปต์ Bash (.sh files)

**การตรวจสอบ:**
```bash
# ตรวจสอบ syntax
bash -n script.sh

# ตรวจสอบ permissions
ls -la *.sh

# ให้สิทธิ์ execute (ถ้าจำเป็น)
chmod +x script.sh
```

**สิ่งที่ต้องตรวจสอบ:**
- Shebang line: `#!/bin/bash`
- Line endings (LF สำหรับ Unix)
- Execute permissions
- ไม่มี syntax errors

### 3.2 Makefile

**การตรวจสอบ:**
```bash
# ตรวจสอบ syntax
make -n target_name

# แสดง targets ทั้งหมด
make help
# หรือ
make -qp | grep "^[a-zA-Z]"
```

**สิ่งที่ต้องตรวจสอบ:**
- ใช้ tabs ไม่ใช่ spaces สำหรับ indentation
- Target names ถูกต้อง
- Dependencies ถูกต้อง

---

## 4. เครื่องมือตรวจสอบเพิ่มเติม

### 4.1 Docker Tools

```bash
# ตรวจสอบ Docker daemon
docker version
docker info

# ตรวจสอบ images
docker images

# ตรวจสอบ containers
docker ps -a

# ทำความสะอาด
docker system prune
```

### 4.2 Text Editors with Validation

**VS Code Extensions:**
- Docker (ms-azuretools.vscode-docker)
- YAML (redhat.vscode-yaml)
- Dockerfile (ms-vscode-remote.remote-containers)

**Configuration สำหรับ VS Code:**
```json
{
    "yaml.validate": true,
    "yaml.format.enable": true,
    "files.eol": "\n",
    "editor.insertSpaces": true,
    "editor.tabSize": 2
}
```

### 4.3 Command Line Tools

```bash
# YAML Validator
pip install yamllint
yamllint docker-compose.yml

# Dockerfile Linter
docker run --rm -i hadolint/hadolint < Dockerfile

# File encoding detection
file -bi filename
```

---

## 5. Checklist การตรวจสอบ

### ✅ Pre-Build Checklist

**ไฟล์พื้นฐาน:**
- [ ] `Dockerfile` มีอยู่และมีเนื้อหาถูกต้อง
- [ ] `docker-compose.yml` ผ่าน syntax check
- [ ] `.gitignore` ครอบคลุมไฟล์ที่ไม่จำเป็น

**การตั้งค่า:**
- [ ] Docker Desktop รันอยู่
- [ ] Internet connection สำหรับ download
- [ ] Disk space เพียงพอ (อย่างน้อย 5GB)

**สิทธิ์ไฟล์:**
- [ ] Script files มี execute permission
- [ ] โฟลเดอร์ทำงานมี write permission

### ✅ Post-Build Checklist

**การ Build:**
- [ ] `docker-compose build` สำเร็จ
- [ ] ไม่มี error หรือ warning สำคัญ
- [ ] Image ถูกสร้างขึ้น (`docker images`)

**การทดสอบ:**
- [ ] Container เริ่มได้ (`docker-compose up -d`)
- [ ] เข้า container ได้ (`docker-compose exec esp32-dev bash`)
- [ ] ESP-IDF tools ใช้งานได้ (`idf.py --version`)

---

## 6. การแก้ไขปัญหาทั่วไป

### 6.1 Dockerfile Issues

**Problem: "unknown instruction"**
```bash
# ตรวจสอบ line endings
dos2unix Dockerfile

# ตรวจสอบ hidden characters
cat -A Dockerfile
```

**Problem: "COPY failed"**
```bash
# ตรวจสอบว่าไฟล์มีอยู่
ls -la .

# ตรวจสอบ .dockerignore
cat .dockerignore
```

### 6.2 docker-compose Issues

**Problem: "Service uses undefined network"**
```bash
# เพิ่ม network definition
networks:
  esp32-network:
    driver: bridge
```

**Problem: "Mount denied"**
```bash
# ใช้ absolute paths หรือตรวจสอบ working directory
pwd
realpath .
```

### 6.3 Permission Issues

**Problem: "Permission denied"**
```bash
# ให้สิทธิ์ script files
chmod +x *.sh

# ตรวจสอบ ownership
ls -la
```

---

## 7. Best Practices

### 7.1 การจัดการไฟล์

1. **ใช้ consistent line endings**
   - Unix: LF (\n)
   - Windows: CRLF (\r\n)
   - แนะนำ LF สำหรับ Docker files

2. **ใช้ proper encoding**
   - UTF-8 without BOM
   - ไม่ใช้ special characters ในชื่อไฟล์

3. **Version control**
   - Commit เฉพาะไฟล์จำเป็น
   - ใช้ .gitignore อย่างถูกต้อง

### 7.2 การทดสอบ

1. **Test early, test often**
   - ตรวจสอบไฟล์ทุกครั้งหลังแก้ไข
   - ใช้ automation tools

2. **Document your process**
   - บันทึกปัญหาและวิธีแก้
   - สร้าง troubleshooting guide

การตรวจสอบไฟล์อย่างถูกวิธีจะช่วยประหยัดเวลาและป้องกันปัญหาในภายหลัง!
