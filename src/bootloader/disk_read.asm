load_disk:
    pusha

    push dx

    mov ah, 0x02 ; read from second sector two, which it 
                 ;        is our first available sector
    mov al, dh   ; how many sectors to read
    mov cl, 0x02
    mov ch, 0x00
    mov dh, 0x00

    int 0x13
    jc disk_error

    pop dx
    cmp al, dh  ; check if BIOS read the number of sectors
                ;     as we wanted
    jne sectors_error
    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print
    jmp dsk_loop

sectors_error:
    mov bx, SECTOR_ERROR
    jmp dsk_loop

dsk_loop:  
    jmp $
    hlt


DISK_ERROR: db 'A disk error occured', 0
SECTOR_ERROR: db 'Sector error occured', 0
