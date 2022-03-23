[org 0x7c00]
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 2 ; read two sectors from initial sector we specified in ah reg
call load_disk


mov dx, [0x9000]
call print_hex


jmp $

%include "disk_read.asm"
%include "print.asm"
%include "print_hex.asm"


times 510 - ($ - $$) db 0
dw 0xaa55

times 256 dw 0x3131; sector 1
times 256 dw 0xfa00 ; sector 2