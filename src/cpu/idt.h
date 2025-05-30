#pragma once
#include "../util/types.h"
#include "isr.h"
#define MAX_IDT_ENTRIES 256 // max number of interrupts

#define SEGMENT_KC 0x08
#define SEGMENT_ATT 0x8E
#define SEGMENT_KD 0x10

typedef struct __attribute__((packed)) {
  uint16_t offset_0;        // offset bits 0..15
  uint16_t segment;        // a code segment selector in GDT or LDT
  uint8_t  ist;             // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
  uint8_t  type_attributes; // gate type, dpl, and p fields
  uint16_t offset_1;        // offset bits 16..31
  uint32_t offset_2;        // offset bits 32..63
  uint32_t zero;            // reserved
} idt_descriptor_t;

typedef struct __attribute__((packed)) {
  uint16_t limit;
  uint64_t* idt_pointer;
} idtr_t;

void edit_idt_descriptor(uint8_t vector, uint64_t isr, uint8_t ist, uint8_t attributes);
void fill_idt_descriptor();
void reload_idt();
void write_idt(idtr_t* idtr_pointer);
