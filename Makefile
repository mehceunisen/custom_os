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

C_SRC_FILES = $(wildcard src/kernel/*.c drivers/*.c)
C_HEADER_FILES = $(wildcard src/kernel/header/*.h driver/header/*.h)
OBJ_FILES = ${C_SRC_FILES:.c=.o}


os.bin: bootloader.bin call_kernel.bin
	cat $^ > $(BUILD_DIR)/$@

call_kernel.bin: call_kernel.o ${OBJ_FILES}
	$(LINK) -o $@ -Ttext 0x1000 $^ --oformat binary

call_kernel.o: $(BOOTLOADER_DIR)/call_kernel.asm
	nasm $(NASM_FLAGS) -o $@ $< -i 'src/bootloader'

%.o: %.c
	${CC} ${CCFLAGS} -ffreestanding -c $< -o $@

bootloader.bin: $(BOOTLOADER_DIR)/bootloader.asm
	nasm $< -f bin -o bootloader.bin -i 'src/bootloader'

run:
	qemu-system-i386 $(BUILD_DIR)/os.bin

clean:
	rm ${OBJ_FILES} *.bin build/os.bin

#bootsect = bootloader
#kernelentry = callkernel