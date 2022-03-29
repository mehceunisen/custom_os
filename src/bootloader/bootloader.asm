[org 0x7c00]

KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl
    mov bp, 0x9000 ;initailize the stack
    mov sp, bp

    call load_kernel
    jmp CODE_SEG:switch_proc_mode



%include "print.asm"
%include "gdt.asm"
%include "switch32.asm"
%include "disk_read.asm"


[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call load_disk
    ret


[bits 32]

%include "switch64.asm"
%include "paging.asm"

main_start_proc_mode:
    call KERNEL_OFFSET
    call main_start_long_mode

main_start_long_mode:
    call detect_cpuid
    call detect_long_mode
    call identity_paging
    call edit_gdt
    jmp CODE_SEG:start_64bit

[bits 64]

start_64bit:
    cli                           ; Clear the interrupt flag.
    mov ax, DATA_SEG              ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.
    mov edi, 0xB8000              ; Set the destination index to 0xB8000.
    mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20.
    mov ecx, 500                  ; Set the C-register to 500.
    rep stosq                     ; Clear the screen.
    hlt                           ; Halt the processor.
    jmp $



BOOT_DRIVE db 0

times 510 - ($ - $$) db 0
dw 0xaa55