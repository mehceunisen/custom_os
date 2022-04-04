#include "../../drivers/header/vga.h"
#include "header/util.h"
#include "../../types.h"

void _start() {
    clear_screen();
    int8* src = (int8*)0x2500;
    for (int i = 0; i < 10; i++)
    {
        *(src + i) = 'A';
    }
    *(src + 10) = '\0';

    char* vid = (char*)VID_ADDR;
    memcpy(src, vid, 11);
    free(VID_ADDR);
    return;
}

