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
