#include "../util/types.h"

// ISR stub generators - exceptions WITHOUT error codes (push dummy 0)
#define ISR_NOERRCODE(num) \
    void isr##num(void) { \
        asm volatile ( \
            "cli\n\t" \
            "push $0\n\t" \
            "push $" #num "\n\t" \
            "jmp isr_common_handler" \
            ::: "memory" \
        ); \
    }

// ISR stub generators - exceptions WITH error codes (don't push dummy)
#define ISR_ERRCODE(num) \
    void isr##num(void) { \
        asm volatile ( \
            "cli\n\t" \
            "push $" #num "\n\t" \
            "jmp isr_common_handler" \
            ::: "memory" \
        ); \
    }

// Function pointer declarations for external use
extern void isr0(void);
extern void isr1(void);
extern void isr2(void);
extern void isr3(void);
extern void isr4(void);
extern void isr5(void);
extern void isr6(void);
extern void isr7(void);
extern void isr8(void);
extern void isr9(void);
extern void isr10(void);
extern void isr11(void);
extern void isr12(void);
extern void isr13(void);
extern void isr14(void);
extern void isr15(void);
extern void isr16(void);
extern void isr17(void);
extern void isr18(void);
extern void isr19(void);
extern void isr20(void);
extern void isr21(void);
extern void isr22(void);
extern void isr23(void);
extern void isr24(void);
extern void isr25(void);
extern void isr26(void);
extern void isr27(void);
extern void isr28(void);
extern void isr29(void);
extern void isr30(void);
extern void isr31(void);

typedef struct __attribute__((packed)) {
    // Pushed by our stub
    uint32_t gs, fs, es, ds;
    uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;  // pusha order
    uint32_t interrupt_num, error_code;
    
    // Pushed by CPU during interrupt
    uint32_t eip, cs, eflags, user_esp, user_ss;
} interrupt_frame;

//static void* isr_stub_table[32];

void interrupt_handler(interrupt_frame* frame);
void isr_common_handler(void);
void idt_install(void);
