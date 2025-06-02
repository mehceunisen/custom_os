#pragma once

typedef enum {
  s_byte = 1,
  s_word = 2,
} symbol_size_t;

void memcpy(void* src, void* dest, short unsigned int no_bytes);
void memmove(void* src, void* dest, short unsigned int no_bytes);
void memwrite(void* dest, long val, short unsigned int no_bytes, symbol_size_t size);
char itoa(int num);
