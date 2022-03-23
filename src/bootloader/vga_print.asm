[bits 32] ;entering 32 bit protected mode

VIDEO_MEM equ 0xb8000
WHITE equ 0x0f

vga_print_init:
    pusha
    mov edx, VIDEO_MEM

vga_print_loop:
    mov al, [ebx] ; char address
    mov ah, WHITE ; property of char

    cmp al, 0
    jmp done

    mov [edx], ax ; store char+properties in edx reg
    add ebx, 1 ; next char
    add edx, 2 ; next video mem position

    jmp vga_print_loop

done:
    popa
    ret
