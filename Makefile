CC := x86_64-elf-gcc #clang
CC_FLAGS := -w -m64 -ffreestanding -c -mno-red-zone #--target=x86_64-none-unknown
CXX := clang++
CXX_FLAGS := -w -m64 -ffreestanding -c -mno-red-zone
LINK := x86_64-elf-ld
LDS := linker.ld
LINK_FLAGS := -static -Bsymbolic -nostdlib -n
NASM_FLAGS := -f elf64

KERNEL_DIR := src/kernel
BOOTLOADER_DIR := src/bootloader
DRIVER_DIR := src/drivers
CPU_DIR := src/cpu
UTIL_DIR := src/util
BUILD_DIR := build
INCLUDE_DIR := ${UTIL_DIR}/include
OBJ_DIR := ${BUILD_DIR}/obj
BIN_DIR := ${BUILD_DIR}/bin

# Source files
C_SRC_FILES = $(wildcard ${KERNEL_DIR}/*.c ${DRIVER_DIR}/*.c ${CPU_DIR}/*.c ${UTIL_DIR}/*.c)
CPP_SRC_FILES = $(wildcard ${KERNEL_DIR}/*.cpp ${DRIVER_DIR}/*.cpp)
C_HEADER_FILES = $(wildcard ${KERNEL_DIR}/include/*.h ${DRIVER_DIR}/include/*.h ${CPU_DIR}/include/*.h ${UTIL_DIR}/include/*.h)

# Object files with proper paths
C_OBJ_FILES = $(addprefix $(OBJ_DIR)/, $(notdir $(C_SRC_FILES:.c=.o)))
CPP_OBJ_FILES = $(addprefix $(OBJ_DIR)/, $(notdir $(CPP_SRC_FILES:.cpp=.o)))

.PHONY: run run-debug clean boot

# Main target
${BIN_DIR}/os.bin: ${BIN_DIR}/bootloader.bin ${BIN_DIR}/call_kernel.bin
	cat $^ > $@
	compiledb -n make

# Kernel binary
${BIN_DIR}/call_kernel.bin: ${OBJ_DIR}/call_kernel.o $(C_OBJ_FILES) $(CPP_OBJ_FILES) | ${BIN_DIR}
	$(LINK) $(LINK_FLAGS) -T ${LDS} -o $@ $^ --oformat binary

# Assembly object file
${OBJ_DIR}/call_kernel.o: $(BOOTLOADER_DIR)/call_kernel.asm | ${OBJ_DIR}
	nasm $(NASM_FLAGS) -o $@ $< -i 'src/bootloader'

# C object files
$(OBJ_DIR)/%.o: $(KERNEL_DIR)/%.c $(C_HEADER_FILES) | ${OBJ_DIR}
	${CC} -I ${INCLUDE_DIR} ${CC_FLAGS} $< -o $@

$(OBJ_DIR)/%.o: $(DRIVER_DIR)/%.c $(C_HEADER_FILES) | ${OBJ_DIR}
	${CC} -I ${INCLUDE_DIR} ${CC_FLAGS} $< -o $@

$(OBJ_DIR)/%.o: $(CPU_DIR)/%.c $(C_HEADER_FILES) | ${OBJ_DIR}
	${CC} -I ${INCLUDE_DIR} ${CC_FLAGS} $< -o $@

$(OBJ_DIR)/%.o: $(UTIL_DIR)/%.c $(C_HEADER_FILES) | ${OBJ_DIR}
	@echo "celdum"
	@echo $@
	${CC} -I ${INCLUDE_DIR} ${CC_FLAGS} $< -o $@

# C++ object files
$(OBJ_DIR)/%.o: $(KERNEL_DIR)/%.cpp $(C_HEADER_FILES) | ${OBJ_DIR}
	${CXX} -I ${INCLUDE_DIR} ${CXX_FLAGS} $< -o $@

$(OBJ_DIR)/%.o: $(DRIVER_DIR)/%.cpp $(C_HEADER_FILES) | ${OBJ_DIR}
	${CXX} -I ${INCLUDE_DIR} ${CXX_FLAGS} $< -o $@

# Bootloader binary
${BIN_DIR}/bootloader.bin: $(BOOTLOADER_DIR)/bootloader.asm | ${BIN_DIR}
	nasm $< -f bin -o $@ -i 'src/bootloader'

# Directory creation
${OBJ_DIR}:
	mkdir -p ${OBJ_DIR}

${BIN_DIR}:
	mkdir -p ${BIN_DIR}

# Targets
run-debug: ${BIN_DIR}/os.bin
	qemu-system-x86_64 -no-reboot -d int -s -fda $<

run: ${BIN_DIR}/os.bin
	qemu-system-x86_64 -s -fda $<

clean:
	rm -f ${OBJ_DIR}/*.o ${BIN_DIR}/*.bin

boot: ${BIN_DIR}/bootloader.bin
	qemu-system-x86_64 -fda $
