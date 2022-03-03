org 0x7c00
bits 16


start:
    jmp main


puts:
    ; save register we will modify
    push si
    push ax

.loop:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0e
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret


main:
    ;setting up the segments
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; setting up the stack
    mov ss, ax
    mov sp, 0x7c00 ;starting pos of stack
    
    ;printing the message
    mov si, msg_hello
    call puts


    hlt

.halt:
    jmp .halt



msg_hello: db 'Hello World', 0



times 510 - ($ - $$) db 0
dw 0xaa55
