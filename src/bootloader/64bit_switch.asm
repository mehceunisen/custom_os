[bits 32]
check_cpu_id:
    pushfd
    pop eax
    ; Copy to ECX as well for comparing later on
    mov ecx, eax
    ; Flip the ID bit
    xor eax, 1 << 21
    ; Copy EAX to FLAGS via the stack
    push eax
    popfd
    ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
    pushfd
    pop eax
    ; Restore FLAGS from the old version stored in ECX (i.e. flipping the ID bit
    ; back if it was ever flipped).
    push ecx
    popfd
    ; Compare EAX and ECX. If they are equal then that means the bit wasn't
    ; flipped, and CPUID isn't supported.
    xor eax, ecx
    jz no_cpu_id

    

    ret    

detect_long_mode:
    mov eax, 0x80000001    ; Set the A-register to 0x80000001.
    cpuid                  ; CPU identification.
    test edx, 1 << 29      ; Test if the LM-bit, which is bit 29, is set in the D-register.
    jz no_long_mode        ; It is less, there is no long mode.
    ret

no_cpu_id:
    jmp $

no_long_mode:
    jmp $