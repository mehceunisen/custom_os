#include <mem_util.h>
#include <drivers/include/vga.h>
#include <cpu/include/gdt.h>
#include <cpu/include/idt.h>
#include <drivers/include/uart.h>

void _start() {
  reload_gdt();
  reload_idt();

  clear_screen();
    
  init_serial();

  kprint("hellow\n");

  __asm__ volatile("int $8");
  __asm__ volatile("int $10");
  __asm__ volatile("int $11");

  SERIAL_PRINT("hello world\n");

  while (1) {}
  return;
}

