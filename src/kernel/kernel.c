#include "../drivers/include/vga.h"
#include <mem_util.h>
#include "../cpu/include/gdt.h"
#include "../cpu/include/idt.h"

void _start() {
  reload_gdt();
  reload_idt();

  clear_screen();
  
  kprint("hellow\n");

  __asm__ volatile("int $8");
  __asm__ volatile("int $10");
  __asm__ volatile("int $11");
  while (1) {}
  return;
}

