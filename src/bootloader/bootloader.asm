mov ah, 0x0e
; defining the offset value in to the extra segment register
mov bx, 0x7c0 ; 0x7c00 doesn't work, i guess it is something related with register size
mov es, bx

mov al, [es:str_var]
int 0x10

mov ds, bx
mov al, [str_var]

int 0x10


jmp $

str_var:
    db 'a'


times 510 - ($ - $$) db 0
dw 0xaa55
