#include "header/util.h"

void memcpy(void* src, void* dest, int16 no_bytes) {
    int i = 0;
    for (; i < no_bytes; i++)
        *((char*)(dest + i)) = *((char*)(src + i));
}

void free(void* src) {
    *((char*)src) = (char*)0x0;
    //this is the best I can do for now
}