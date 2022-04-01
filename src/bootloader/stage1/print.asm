print:
    mov ah, 0x0e
    .print_char:
        mov al, [bx]
        cmp al, 0
        je exit
        int 0x10
        inc bx
        jmp .print_char


exit:
    jmp $
