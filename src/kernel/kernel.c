#include "../drivers/header/vga.h"
#include "header/util.h"
#include "../cpu/gdt.h"
#include "../cpu/idt.h"
void _start() {
  reload_gdt();
  reload_idt();

  clear_screen();
  
  kprint("hellow\n");

  __asm__ volatile("int $13");
  __asm__ volatile("int $14");
  __asm__ volatile("int $15");
  while (1) {}
  return;
}

