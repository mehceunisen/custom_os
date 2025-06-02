#include "include/gdt.h"

gdt_descriptor_t __gdt_descriptor_table[GDT_MAX_DESCRIPTORS];
static gdtr_t gdtr;

void edit_gdt_descriptor(uint64_t base, uint32_t limit, uint8_t access_byte, uint8_t flags, uint8_t gdt_index) 
{
  __gdt_descriptor_table[gdt_index].limit = limit;

  __gdt_descriptor_table[gdt_index].base_low = base & 0xFFFF;
  __gdt_descriptor_table[gdt_index].base_mid = (base >> 16) & 0xFF;
  __gdt_descriptor_table[gdt_index].base_high = (base >> 24) & 0xFF;

  __gdt_descriptor_table[gdt_index].access_byte = access_byte;
  __gdt_descriptor_table[gdt_index].granularity = (
      ((flags << 4) & 0xF0) | ((limit >> 16) & 0x0F) );
}

void fill_gdt_descriptor() {

  gdtr.limit = (sizeof(gdt_descriptor_t) * GDT_MAX_DESCRIPTORS) - 1;
  gdtr.base = (uint32_t*)__gdt_descriptor_table;

  uint8_t gdt_idx = 0;

  edit_gdt_descriptor(0, 0, 0, 0, gdt_idx++);
  edit_gdt_descriptor(0, 0xFFFFF, 0x9A, 0xA, gdt_idx++);
  edit_gdt_descriptor(0, 0xFFFFF, 0x92, 0xC, gdt_idx++);
  edit_gdt_descriptor(0, 0xFFFFF, 0xFA, 0xA, gdt_idx++);
  edit_gdt_descriptor(0, 0xFFFFF, 0xF2, 0xC, gdt_idx++);

}

void write_gdt(gdtr_t* gdtr, uint16_t code, uint16_t data) {
    __asm__ volatile (
        "pushfq\n\t"                    // Save flags
        "cli\n\t"                       // Disable interrupts
        "lgdt %0\n\t"                   // Load GDT
        "popfq\n\t"                     // Restore flags
        "mov %1, %%ds\n\t"              // Load data segment selector
        "mov %1, %%es\n\t"              // Load extra segment selector  
        "mov %1, %%ss\n\t"              // Load stack segment selector
        "pushq %2\n\t"                  // Push code selector
        "pushq $1f\n\t"                 // Push return address
        "pushq %2\n\t"           // Push code selector
        "leaq 1f(%%rip), %%rax\n\t"  // Load address of label
        "pushq %%rax\n\t"        // Push return address
        "lretq\n\t"             // Long return to reload CS
        "1:\n\t"                        // Label for return address
        "addq $16, %%rsp"               // Clean up stack
        :
        : "m" (*gdtr),                  // Input: GDTR structure
          "r" (data),          // Input: data segment selector
          "r" ((uint64_t)code) // Input: code segment selector (as 64-bit)
        : "memory", "cc"                // Clobbered: memory and condition codes
    );
}

void reload_gdt() {
  fill_gdt_descriptor();
  write_gdt(&gdtr, GDT_OFFSET_KC, GDT_OFFSET_KD);
}
