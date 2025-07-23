# Git Ignore Guide for ESP32 Docker QEMU Project

## ภาพรวม

ไฟล์ `.gitignore` ในโปรเจ็กต์นี้ถูกออกแบบมาเพื่อจัดการไฟล์ที่ไม่ควรถูก track ใน Git repository สำหรับ ESP32 development environment ที่ใช้ Docker และ QEMU

## หมวดหมู่ของไฟล์ที่ถูก ignore

### 1. **C/C++ Compilation Artifacts**
```gitignore
*.o, *.ko, *.obj     # Object files
*.elf               # Executable and Linkable Format files
*.map               # Memory map files
*.a, *.lib          # Static library files
*.so, *.dll         # Shared library files
```

### 2. **ESP32/ESP-IDF Specific Files**
```gitignore
build/              # Build output directory
sdkconfig*          # ESP-IDF configuration files
*.bin               # Binary firmware files
bootloader/         # Bootloader build files
partition_table/    # Partition table files
managed_components/ # Component dependencies
```

**ไฟล์สำคัญที่ควร track:**
- `CMakeLists.txt` - Build configuration
- `main/` - Source code directory
- `components/` - Custom components (แต่ไม่รวม build artifacts)

### 3. **Docker Environment**
```gitignore
.docker/                    # Docker working files
docker-compose.override.yml # Local docker-compose overrides
volumes/                    # Docker volume data
logs/                      # Container logs
```

**ไฟล์ที่ควร track:**
- `Dockerfile` - Container configuration
- `docker-compose.yml` - Service definitions

### 4. **QEMU Simulation**
```gitignore
qemu_simulation/    # QEMU working directory
*.qcow2, *.img     # Virtual disk images
qemu*.log          # QEMU log files
```

### 5. **Development Tools**
```gitignore
.gdb_history       # GDB command history
*.gdb              # GDB scripts
.vscode/           # VS Code workspace settings (selective)
.idea/             # JetBrains IDE files
```

**VS Code Settings (Selective Ignore):**
```gitignore
.vscode/
!.vscode/settings.json    # Keep shared settings
!.vscode/tasks.json       # Keep build tasks
!.vscode/launch.json      # Keep debug configs
!.vscode/extensions.json  # Keep recommended extensions
```

### 6. **Lab Submission Management**
```gitignore
# Keep structure, ignore student content
submissions/*/screenshots/*.png
submissions/*/video_demo.mp4
submissions/*/report.pdf

# But keep examples and documentation
!submissions/example-submission/
!submissions/README.md
```

## การใช้งานใน Lab

### สำหรับนักศึกษา:

**ไฟล์ที่ควร commit:**
```bash
# หลักๆ
main/hello_world_main.c
CMakeLists.txt
Dockerfile
docker-compose.yml

# Optional
Makefile
esp32-helper.sh
run_qemu.sh
README.md
```

**ไฟล์ที่ไม่ควร commit:**
```bash
build/               # Build artifacts
sdkconfig           # Personal configurations
*.bin, *.elf        # Binary files
.vscode/settings.json # Personal IDE settings
qemu.log            # Simulation logs
```

### สำหรับอาจารย์:

**การตรวจสอบ gitignore:**
```bash
# ดูไฟล์ที่ถูก track
git ls-files

# ดูไฟล์ที่ถูก ignore
git status --ignored

# ตรวจสอบว่าไฟล์เฉพาะถูก ignore หรือไม่
git check-ignore filename.ext
```

## Best Practices

### 1. **การทดสอบ .gitignore**
```bash
# สร้างไฟล์ทดสอบ
touch build/test.bin
touch sdkconfig.test

# ตรวจสอบสถานะ
git status

# ไฟล์เหล่านี้ไม่ควรปรากฏใน untracked files
```

### 2. **การเพิ่ม exception**
```bash
# หากต้องการ track ไฟล์ในโฟลเดอร์ที่ถูก ignore
echo "!build/important.txt" >> .gitignore

# หรือใช้ force add
git add -f build/important.txt
```

### 3. **การจัดการไฟล์ที่ commit ไปแล้ว**
```bash
# ลบไฟล์ออกจาก Git แต่เก็บไว้ในเครื่อง
git rm --cached filename

# ลบทั้งโฟลเดอร์
git rm -r --cached build/

# อัปเดต .gitignore แล้ว commit
git add .gitignore
git commit -m "Update gitignore for build artifacts"
```

## การปรับแต่งสำหรับโปรเจ็กต์เฉพาะ

### หากใช้ IDE อื่น:
```gitignore
# Eclipse
.project
.cproject
.metadata/

# Code::Blocks
*.cbp
*.layout
*.depend

# Vim
*.swp
*.swo
Session.vim
```

### หากใช้ CI/CD:
```gitignore
# GitHub Actions
.github/workflows/*.yml.local

# Jenkins
.jenkins/

# CI artifacts
ci-artifacts/
test-results/
```

### หากใช้ Component Manager:
```gitignore
# ESP Component Registry
managed_components/
dependencies.lock
```

## การตรวจสอบและบำรุงรักษา

### คำสั่งที่มีประโยชน์:
```bash
# ดูขนาด repository
git count-objects -vH

# ลบไฟล์ที่ไม่จำเป็นออกจาก history
git filter-branch --tree-filter 'rm -rf build/' HEAD

# ทำความสะอาด repository
git gc --aggressive --prune=now
```

### การตรวจสอบประจำ:
1. ตรวจสอบขนาด repository เป็นระยะ
2. ดูว่ามีไฟล์ binary ขนาดใหญ่ถูก commit หรือไม่
3. อัปเดต .gitignore เมื่อมีไฟล์ประเภทใหม่

## ตัวอย่างการใช้งาน

### Workflow ปกติของนักศึกษา:
```bash
# 1. Clone repository
git clone <repo-url>
cd lab-04-esp32-docker-qemu

# 2. สร้างและทดสอบ
docker-compose build
docker-compose up -d
docker-compose exec esp32-dev bash

# 3. พัฒนาโปรแกรม
# แก้ไข main/hello_world_main.c
# idf.py build

# 4. Commit เฉพาะ source code
git add main/hello_world_main.c
git add CMakeLists.txt
git commit -m "Update hello world program"

# 5. ตรวจสอบว่าไม่มีไฟล์ไม่พึงประสงค์
git status
# ไม่ควรเห็น build/, *.bin, sdkconfig
```

การตั้งค่า .gitignore ที่ดีจะช่วยให้ repository สะอาด เล็ก และง่ายต่อการจัดการ!
