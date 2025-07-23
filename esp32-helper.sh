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
