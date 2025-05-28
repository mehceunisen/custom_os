CC := x86_64-elf-gcc
CC_FLAGS := -w -m64 -ffreestanding -c -mno-red-zone #--target=x86_64-none-unknown
CXX := clang++

LINK := x86_64-elf-ld
LDS := linker.ld
LINK_FLAGS :=-static -Bsymbolic -nostdlib -n

NASM_FLAGS := -f elf64

KERNEL_DIR := src/kernel
BOOTLOADER_DIR := src/bootloader
DRIVER_DIR := src/drivers
CPU_DIR := src/cpu
BUILD_DIR := build
OBJ_DIR := build/obj

C_SRC_FILES = $(wildcard ${KERNEL_DIR}/*.c ${DRIVER_DIR}/*.c ${CPU_DIR}/*.c)
CPP_SRC_FILES = $(wildcard ${KERNEL_DIR}/*.cpp ${DRIVER_DIR}/*.cpp)
C_HEADER_FILES = $(wildcard ${KERNEL_DIR}/header/*.h ${DRIVER_DIR}/header/*.h)
C_OBJ_FILES = ${C_SRC_FILES:.c=.o}
CPP_OBJ_FILES = ${CPP_SRC_FILES:.cpp=.o}

os.bin: bootloader.bin call_kernel.bin
	cat $^ > $@

call_kernel.bin: call_kernel.o $(C_OBJ_FILES) $(CPP_OBJ_FILES)
	$(LINK) $(LINK_FLAGS) -T ${LDS} -o $@  $^ --oformat binary

call_kernel.o: $(BOOTLOADER_DIR)/call_kernel.asm
	nasm $(NASM_FLAGS) -o $@ $< -i 'src/bootloader'

%.o: %.c ${C_HEADER_FILES}
	${CC} ${CC_FLAGS} -c $< -o $@

%.o: %.cpp ${_HEADER_FILES}
	${CXX} -w -I -mtune=x86_64 -ffreestanding -c $< -o $@

bootloader.bin: $(BOOTLOADER_DIR)/bootloader.asm
	nasm $< -f bin -o bootloader.bin -i 'src/bootloader'

run:
	qemu-system-x86_64 -s -fda os.bin

clean:
	rm *.o *.bin ${C_OBJ_FILES} ${CPP_OBJ_FILES}

boot: bootloader.bin
	qemu-system-x86_64  bootloader.bin
