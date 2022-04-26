#include "../../drivers/header/vga.h"
#include "header/util.h"
#include "../../types.h"

void _start() {
    clear_screen();

    char x[2] = {0};
    x[1] = '\0';

    for (int i = 0; i < 24; i++) {
        x[0] = itoa(i);
        kprint_at(x, 0, i);
    }

    kprint_at("This text forces the kernel to scroll. Row 0 will disappear. ", 60, 24);
    kprint("And with this text, the kernel will scroll again, and row 1 will disappear too!");


    return;
}

