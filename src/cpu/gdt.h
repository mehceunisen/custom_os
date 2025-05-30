#pragma once
#include "../util/types.h"

#define GDT_MAX_DESCRIPTORS 6

#define SEG_NULL_ACCESS_BYTE  0x0
#define SEG_KMC_ACCESS_BYTE   0x9A
#define SEG_KMD_ACCESS_BYTE   0x92
#define SEG_UMC_ACCESS_BYTE   0xFA
#define SEG_UMD_ACCESS_BYTE   0xF2
#define SEG_TSS_ACCESS_BYTE   0x89

#define GDT_OFFSET_KC      (0x01 * 0x08)
#define GDT_OFFSET_KD      (0x02 * 0x08)

typedef struct __attribute__((packed)) {
  uint16_t limit;
  uint16_t base_low;
  uint8_t base_mid;
  uint8_t access_byte;
  uint8_t granularity;
  uint8_t base_high;
} gdt_descriptor_t;

// TODO: Implement TSS
typedef struct __attribute__((packed)) {
  uint16_t limit_0;
  uint16_t base_0;
  uint8_t base_1;
  uint8_t access_0;
  uint8_t granularity;
  uint8_t base_2;
  uint32_t base_3;
  uint32_t reserved;
} gdt_tss_descriptor_t;

typedef struct __attribute__((packed)) {
  uint16_t limit;
  uint32_t* base;
} gdtr_t;

void edit_gdt_descriptor(uint64_t base, uint32_t limit, uint8_t access_byte, uint8_t flags, uint8_t gdt_index);
void fill_gdt_descriptor();
void write_gdt(gdtr_t* gdtr, uint16_t code, uint16_t data);
void reload_gdt();
