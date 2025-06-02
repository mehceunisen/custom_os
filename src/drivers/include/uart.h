#pragma once

#define PORT 0x3f8

#ifdef DEBUG

#define SERIAL_PRINT(s)                   \
  do {                                    \
    const char* _str = (s);               \
    for (int i = 0; _str[i] != '\0'; ++i) \
    send_char(_str[i]);                   \
  } while (0)

#else

#define SERIAL_PRINT(s)

#endif

typedef enum {
  port_data = PORT,
  port_interrupt_enable,
  port_fifo_ctrl,
  port_line_ctrl,
  port_modem_ctrl,
} port_base_t;

extern int init_serial();
void send_char(char c);

