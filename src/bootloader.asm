org 0x7c00

mov ah, 0x0e
mov al, 65

int 0x10



times 510 - ($ - $$) db 0
dw 0xaa55
