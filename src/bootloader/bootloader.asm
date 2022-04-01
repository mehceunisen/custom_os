[org 0x7c00] ; bootloader offset
    mov bp, 0x9000 ; set the stack
    mov sp, bp

    call enable_a20
    call switch_to_pm
    jmp $ ; this will actually never be executed

%include "print.asm"
%include "gdt.asm"
%include "32bit_print.asm"
%include "32bit_switch.asm"
%include "64bit_gdt.asm"

[bits 32]

BEGIN_PM: ; after the switch we will get here
    call switch_64bit
    jmp $

switch_64bit:
    ; call check_cpu_id
    ; call detect_long_mode
    mov edi, 0x1000    ; Set the destination index to 0x1000.
    mov cr3, edi       ; Set control register 3 to the destination index.
    xor eax, eax       ; Nullify the A-register.
    mov ecx, 4096      ; Set the C-register to 4096.
    rep stosd          ; Clear the memory.
    mov edi, cr3       ; Set the destination index to control register 3.
    
    mov DWORD [edi], 0x2003      ; Set the uint32_t at the destination index to 0x2003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x3003      ; Set the uint32_t at the destination index to 0x3003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x4003      ; Set the uint32_t at the destination index to 0x4003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.

    mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
    mov ecx, 512                 ; Set the C-register to 512.
 
    .SetEntry:
        mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
        add ebx, 0x1000              ; Add 0x1000 to the B-register.
        add edi, 8                   ; Add eight to the destination index.
        loop .SetEntry               ; Set the next entry.
    
    mov eax, cr4                 ; Set the A-register to control register 4.
    or eax, 1 << 5               ; Set the PAE-bit, which is the 6th bit (bit 5).
    mov cr4, eax 

    call switch_lm

%include "identity_paging.asm"
%include "64bit_switch.asm"


[bits 64]

baba:
    cli                           ; Clear the interrupt flag.
    mov ax, GDT64.Data            ; Set the A-register to the data descriptor.
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
[bits 32]
; bootsector
times 510-($-$$) db 0
dw 0xaa55
