#include "header/util.h"

void memcpy(void* src, void* dest, short unsigned int no_bytes) {
    int i = 0;
    for (; i < no_bytes; i++)
        *((char*)(dest + i)) = *((char*)(src + i));
}

void memmove(void* src, void* dest, short unsigned int no_bytes) {
  char* _src = (char*)src;
  char* _dest = (char*)dest;

  if (_src > _dest || _dest >= _src + no_bytes) {
    for (int i = 0; i < no_bytes; ++i) {
      _dest[i] = _src[i];
    }
  }
  else {
    for (int i = no_bytes - 1; i > 0; --i) {
      _dest[i - 1] = _src[i - 1];
    }
  }
}

void memwrite(void* dest, long val, short unsigned int no_bytes, symbol_size_t size) {
  for (int i = 0; i < no_bytes; i += size)
    *(char*)(dest + i) = val;

}

char itoa(int num) {
    //quite a simple one but get's the job done
    return '0' + num;
}

