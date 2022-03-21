mov al, [bx]

print:
    cmp al, 0
    je exit
    int 0x10
    inc bx
    mov al, [bx]
    jmp print


exit:
    jmp $
    hlt
