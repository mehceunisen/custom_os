#include "../../drivers/header/vga.h"
#include "header/util.h"
#include "../../types.h"

void _start() {
    clear_screen();

    char* src = (char*)0x2500;
    for (int i = 0; i < 10; i++)
    {
        *(src + i) = 97;
    }
    *(src + 11) = '\0';
    char* dst = (char*)VID_ADDR;
    memcpy(src, dst, 11);

    return;
}

