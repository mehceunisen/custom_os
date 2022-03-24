all: kernel.o bootloader.o bootloader.bin
# compiles all the kernel C source codes
kernel.o: src/kernel/*.c
	gcc -m32 -mtune=i386 -ffreestanding -c $< -o build/obj/kernel/$@

# compiles the bootloader
bootloader.o: src/bootloader/bootloader.asm
	nasm $< -f bin -o build/obj/bootloader/$@ -i 'src/bootloader'

bootloader.bin: src/bootloader/bootloader.asm
	nasm $< -f bin -o build/$@ -i 'src/bootloader'


# fantasy stuff
clean:
	rm build/obj/kernel/*.o build/obj/bootloader/*.o build/*.bin

cleanobj:
	rm build/obj/kernel/*.o build/obj/bootloader/*.o

run: build/bootloader.bin
	qemu-system-x86_64 $<