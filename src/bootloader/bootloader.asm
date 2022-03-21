[org 0x7c00]

mov ah, 0x0e
mov bx, str_var
mov al, [bx]


call print



%include "print.asm"



str_var:
    db 'Hello World!', 0


times 510 - ($ - $$) db 0
dw 0xaa55
