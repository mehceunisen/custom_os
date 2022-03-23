print:
    mov ah, 0x0e
    cmp al, 0
    je exit
    int 0x10
    inc bx
    mov al, [bx]
    jmp print

print_one_char:
    mov ah, 0x0e
    mov al, [bx]
    int 0x10
    ret


exit:
    jmp $
    hlt
