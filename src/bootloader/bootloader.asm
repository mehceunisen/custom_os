org 0x7c00

mov ah, 0x0e

mov bp, 0x8000
mov sp, bp
;initializing the stack


push 'A'
push 'B'
push 'C'

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

; clearing up the stack

times 510 - ($ - $$) db 0
dw 0xaa55
