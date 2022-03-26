#include "header/macros.h"

u_char port_byte_in(u_short port) {
    u_char result;

    __asm__("in %%dx, %%al": "=a"(result): "d"(port));

    return result;
}

void port_byte_out(u_short port, u_char data) {
    __asm__("out %%al, %%dx" : : "a"(data), "d"(port));
}

u_short port_word_in (u_short port) {
    u_short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

void port_word_out(u_short port, u_short data) {
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}

