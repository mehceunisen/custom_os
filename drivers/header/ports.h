#pragma once
#include "macros.h"

u_char port_byte_in(u_short port);
void port_byte_out(u_short port, u_char data);
u_short port_word_in(u_short port);
void port_word_out(u_short port, u_short data);