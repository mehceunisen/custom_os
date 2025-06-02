#include "include/uart.h"
#include <drivers/include/ports.h>
#include <drivers/include/vga.h>


int init_serial() {
  port_byte_out(port_interrupt_enable, 0x00);    // Disable all interrupts
  port_byte_out(port_line_ctrl, 0x80);    // Enable DLAB (set baud rate divisor)
  port_byte_out(port_data, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
  port_byte_out(port_interrupt_enable, 0x00);    //                  (hi byte)
  port_byte_out(port_line_ctrl, 0x03);    // 8 bits, no parity, one stop bit
  port_byte_out(port_fifo_ctrl, 0xC7);    // Enable FIFO, with 14-byte threshold
  port_byte_out(port_modem_ctrl, 0x0B);    // IRQs enabled, RTS/DSR set
  port_byte_out(port_interrupt_enable, 0x01);    // interrupt enable 
}

void send_char(char c) {
  port_byte_out(PORT, c);
}

