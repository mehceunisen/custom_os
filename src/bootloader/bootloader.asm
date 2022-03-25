[org 0x7c00]

KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl
mov bp, 0x9000 ;initailize the stack
mov sp, bp

call load_kernel
call switch_proc_mode
jmp $



%include "print.asm"
%include "gdt.asm"
%include "vga_print.asm"
%include "switch32.asm"
%include "disk_read.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call load_disk
    ret


[bits 32]
main_start_proc_mode:
    mov ebx, MSG_PROT_MODE
    call vga_print
    call KERNEL_OFFSET
    jmp $


BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Entered 32-bit protected mode", 0

times 510 - ($ - $$) db 0
dw 0xaa55