[org 0x7c00]

mov [BOOT_DISK], dl

mov bp, 0x7c00
mov sp, bp

call read_disk

; mov ah, 0x0e
; mov al, [PROGRAM_SPACE]
; int 0x10

%include "print.asm"
%include "disk_read.asm"

; anan db "anaaaaaan", 0

times 510 - ($ - $$) db 0
dw 0xaa55