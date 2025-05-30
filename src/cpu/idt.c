#include "idt.h"

idt_descriptor_t __idt_descriptors[MAX_IDT_ENTRIES];
idtr_t __idtr;
void* isr_stub_table[32] = {
    isr0,  isr1,  isr2,  isr3,  isr4,  isr5,  isr6,  isr7,
    isr8,  isr9,  isr10, isr11, isr12, isr13, isr14, isr15,
    isr16, isr17, isr18, isr19, isr20, isr21, isr22, isr23,
    isr24, isr25, isr26, isr27, isr28, isr29, isr30, isr31
  };
void edit_idt_descriptor(uint8_t vector, uint64_t isr, uint8_t ist, uint8_t attributes) {
  idt_descriptor_t* __idt = &__idt_descriptors[vector];
  __idt->offset_0 = isr & 0xFFFF;
  __idt->offset_1 = (isr >> 16) & 0xFFFF; 
  __idt->offset_2 = (isr >> 32) & 0xFFFFFFFF;
  __idt->segment = SEGMENT_KC;
  __idt->ist = ist;
  __idt->type_attributes = attributes;
  __idt->zero = 0;
}

void fill_idt_descriptor() {
  for (int i = 0; i < MAX_IDT_ENTRIES; ++i) {
    edit_idt_descriptor(i, 0, 0, 0);
  }

  for (int i = 0; i < 32; ++i) {
    edit_idt_descriptor(i, (uint64_t)isr_stub_table[i], SEGMENT_KC, SEGMENT_ATT);
  }
}

void reload_idt() {
  __idtr.limit = sizeof(idt_descriptor_t) * MAX_IDT_ENTRIES - 1;
  __idtr.idt_pointer = (uint64_t*)__idt_descriptors;


  fill_idt_descriptor();
  write_idt(&__idtr);

}

void write_idt(idtr_t* idtr_pointer) {
  __asm__ volatile (
      "pushfq\n\t" // push current flags to register
      "cli\n\t"   // disable interrupts
      "lidt %0\n\t" // loadt 0th paramter to idt register
      "sti\n\t"
      "popfq\n\t" // pop current flags, re-enable them
      :
      : "m" (*idtr_pointer) // this is a memory region, not pointer
      : "memory"                  // use this region to r/w
      );
}
