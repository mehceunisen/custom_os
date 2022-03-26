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
OBJ_FILES = $(OBJ_DIR)/*.o

C_SRC_FILES = $(wildcard src/kernel/*.c driver/*.c)
C_HEADER_FILES = $(wildcard src/kernel/header/*.h driver/header/*.h)
all:bootloader.bin kernel.o ports.o call_kernel.o call_kernel.bin os.bin
obj: bootloader.bin kernel.o ports.o call_kernel.o
link: call_kernel.bin os.bin

%.o: $(KERNEL_DIR)/%.c
	gcc $(CC_FLAGS) $< -o $(OBJ_DIR)/$@
%.o: $(DRIVER_DIR)/%.c
	gcc $(CC_FLAGS) $< -o $(OBJ_DIR)/$@

print:
	


call_kernel.o: $(BOOTLOADER_DIR)/call_kernel.asm
	nasm $(NASM_FLAGS) -o $(OBJ_DIR)/$@ $< -i 'src/bootloader'

bootloader.bin: $(BOOTLOADER_DIR)/bootloader.asm
	nasm $< -f bin -o $(BUILD_DIR)/bootloader.bin -i 'src/bootloader'



call_kernel.bin: $(OBJ_DIR)/kernel.o $(OBJ_DIR)/ports.o $(OBJ_DIR)/call_kernel.o
	$(LINK) -o $(BUILD_DIR)/$@ -Ttext 0x1000 $^ --oformat binary

os.bin: $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/call_kernel.bin
	cat $^ > $(BUILD_DIR)/$@

run:
	qemu-system-i386 $(BUILD_DIR)/os.bin


clean:
	rm $(OBJ_DIR)/*.o $(BUILD_DIR)/*.bin

#bootsect = bootloader
#kernelentry = callkernel