#include "../drivers/header/vga.h"
#include "header/util.h"
#include "../cpu/gdt.h"
void _start() {
  reload_gdt();
  clear_screen();
  
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 123\n");
  kprint("testing 456\n");
  kprint("testing 456\n");
  kprint("testing 456\n");
  kprint("testing 456\n");
  kprint("testing 456\n");
  kprint("testing 456\n");
  while (1) {}
  return;
}

