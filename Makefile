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
