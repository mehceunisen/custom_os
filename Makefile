all: kernel.o call_kernel.o call_kernel.bin bootloader.bin os.bin
# compiles all the kernel C source codes
kernel.o: src/kernel/*.c
	gcc -fno-pie -Wall -m32 -mtune=i386 -ffreestanding -c $< -o build/obj/kernel/$@

# compiles the bootloader
os.bin: build/bootloader.bin build/call_kernel.bin
	cat $^ > build/$@
	

call_kernel.bin: build/obj/kernel/kernel.o build/obj/bootloader/call_kernel.o 
	ld -m elf_i386 -o build/$@ -Ttext 0x1000 build/obj/kernel/kernel.o build/obj/bootloader/call_kernel.o --oformat binary

bootloader.bin: src/bootloader/bootloader.asm
	nasm $< -f bin -o build/$@ -i 'src/bootloader'

call_kernel.o: src/bootloader/call_kernel.asm
	nasm -f elf32 -o build/obj/bootloader/$@ $< -i 'src/bootloader'



# fantasy stuff
clean:
	rm build/obj/kernel/*.o build/obj/bootloader/*.o build/*.bin

cleanobj:
	rm build/obj/kernel/*.o build/obj/bootloader/*.o

run: build/os.bin
	qemu-system-i386 -fda $<