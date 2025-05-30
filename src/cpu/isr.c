#pragma once

#include "isr.h"
#include "../drivers/header/vga.h"
#include "../drivers/header/ports.h"

ISR_NOERRCODE(0)   // Divide by Zero
ISR_NOERRCODE(1)   // Debug
ISR_NOERRCODE(2)   // Non-Maskable Interrupt
ISR_NOERRCODE(3)   // Breakpoint
ISR_NOERRCODE(4)   // Overflow
ISR_NOERRCODE(5)   // Bound Range Exceeded
ISR_NOERRCODE(6)   // Invalid Opcode
ISR_NOERRCODE(7)   // Device Not Available
ISR_ERRCODE(8)     // Double Fault (has error code)
ISR_NOERRCODE(9)   // Coprocessor Segment Overrun
ISR_ERRCODE(10)    // Invalid TSS (has error code)
ISR_ERRCODE(11)    // Segment Not Present (has error code)
ISR_ERRCODE(12)    // Stack Segment Fault (has error code)
ISR_ERRCODE(13)    // General Protection Fault (has error code)
ISR_ERRCODE(14)    // Page Fault (has error code)
ISR_NOERRCODE(15)  // Reserved
ISR_NOERRCODE(16)  // x87 Floating Point Exception
ISR_ERRCODE(17)    // Alignment Check (has error code)
ISR_NOERRCODE(18)  // Machine Check
ISR_NOERRCODE(19)  // SIMD Floating Point Exception
ISR_NOERRCODE(20)  // Virtualization Exception
ISR_NOERRCODE(21)  // Reserved
ISR_NOERRCODE(22)  // Reserved
ISR_NOERRCODE(23)  // Reserved
ISR_NOERRCODE(24)  // Reserved
ISR_NOERRCODE(25)  // Reserved
ISR_NOERRCODE(26)  // Reserved
ISR_NOERRCODE(27)  // Reserved
ISR_NOERRCODE(28)  // Reserved
ISR_NOERRCODE(29)  // Reserved
ISR_NOERRCODE(30)  // Reserved
ISR_NOERRCODE(31)  // Reserved

// Common ISR handler that all stubs jump to
void isr_common_handler(void) {
    asm volatile (
        "push %%rax\n\t"
        "push %%rbx\n\t" 
        "push %%rcx\n\t"
        "push %%rdx\n\t"
        "push %%rsi\n\t"
        "push %%rdi\n\t"
        "push %%rbp\n\t"
        "push %%r8\n\t"
        "push %%r9\n\t"
        "push %%r10\n\t"
        "push %%r11\n\t"
        "push %%r12\n\t"
        "push %%r13\n\t"
        "push %%r14\n\t"
        "push %%r15\n\t"

        // In 64-bit mode, segments are mostly ignored (flat memory model)
        // DS/ES are automatically set to 0 by CPU in 64-bit mode

        "mov %%rsp, %%rdi\n\t"         // Pass interrupt frame as first argument
        "call interrupt_handler\n\t"   // Call C interrupt handler
        
        // Restore all general purpose registers
        "pop %%r15\n\t"
        "pop %%r14\n\t"
        "pop %%r13\n\t"
        "pop %%r12\n\t"
        "pop %%r11\n\t"
        "pop %%r10\n\t"
        "pop %%r9\n\t"
        "pop %%r8\n\t"
        "pop %%rbp\n\t"
        "pop %%rdi\n\t"
        "pop %%rsi\n\t"
        "pop %%rdx\n\t"
        "pop %%rcx\n\t"
        "pop %%rbx\n\t"
        "pop %%rax\n\t"

        "add $16, %%rsp\n\t"           // Remove interrupt_num and error_code (8 bytes each)
        "iretq"                        // 64-bit return from interrupt
        ::: "memory" 
        );
}
void interrupt_handler(interrupt_frame* frame) {
  kprint("caught an interrupt\n");
//  while(1) {}
}
