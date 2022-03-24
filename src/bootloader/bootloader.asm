[org 0x7c00]
mov bp, 0x9000
mov sp, bp

; mov bx, MSG_REAL_MODE
; call print ; This will be written after the BIOS messages

call switch_proc_mode


%include "print.asm"
%include "gdt.asm"
%include "vga_print.asm"
%include "switch32.asm"
[bits 32]
main_start_proc_mode:
    mov ebx, MSG_PROT_MODE
    call vga_print ; Note that this will be written at the top left corner
    call vga_print_loop
    jmp $

MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "anasinin amini gotten girip ustten yalayip siktim", 0

times 510 - ($ - $$) db 0
dw 0xaa55