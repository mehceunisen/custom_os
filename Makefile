CC := gcc
CC_FLAGS := -g -fno-pie -Wall -ffreestanding -c

LINK := ld
LINK_FLAGS := -m elf_i386

NASM_FLAGS := -f elf64

KERNEL_DIR := src/kernel
BOOTLOADER_DIR := src/bootloader
DRIVER_DIR := drivers
BUILD_DIR := build
OBJ_DIR := build/obj

C_SRC_FILES = $(wildcard src/kernel/*.c driver/*.c)
C_HEADER_FILES = $(wildcard src/kernel/header/*.h driver/header/*.h)

OBJ_FILES = ${C_SRC_FILES:.c=.o}

all:bootloader.bin kernel.o ports.o call_kernel.o call_kernel.bin os.bin
obj: bootloader.bin kernel.o ports.o call_kernel.o
link: call_kernel.bin os.bin


%.o: $(KERNEL_DIR)/%.c
	gcc $(CC_FLAGS) $< -o $@
%.o: $(DRIVER_DIR)/%.c
	gcc $(CC_FLAGS) $< -o $@

print:
	


call_kernel.o: $(BOOTLOADER_DIR)/call_kernel.asm
	nasm $(NASM_FLAGS) -o $@ $< -i 'src/bootloader'

bootloader.bin: $(BOOTLOADER_DIR)/bootloader.asm
	nasm $< -f bin -o bootloader.bin -i 'src/bootloader'

call_kernel.bin: call_kernel.o *.o
	$(LINK) -o $@ -Ttext 0x1000 $^ --oformat binary

os.bin: bootloader.bin call_kernel.bin
	cat $^ > $(BUILD_DIR)/$@

run:
	qemu-system-i386 $(BUILD_DIR)/os.bin

clean:
	rm *.o *.bin build/os.bin

#bootsect = bootloader
#kernelentry = callkernel