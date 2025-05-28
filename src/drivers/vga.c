#include "header/vga.h"
#include "header/ports.h"
#include "../kernel/header/util.h"

int _eval_offset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int _eval_offset_row(int offset) { return offset / (2 * MAX_COLS); }
int _eval_offset_col(int offset) { return (offset - (_eval_offset_row(offset)*2*MAX_COLS))/2; }

int get_cursor_offset();
void set_cursor_offset(int offset);

void kprint(char* message) {
  for (int i = 0; message[i] != '\0'; ++i) {
    print_char(message[i], WHITE_ON_BLACK);
  }
}

void clear_screen() {
  char* base_addr = (char*)VID_ADDR;
  
  memwrite((void*)VID_ADDR, 0x00, MAX_ROWS * MAX_COLS, s_byte);

  set_cursor_offset(0);
}

void scroll() {
  memmove((void*)VID_ADDR + ONE_COL_OFFSET, (void*)VID_ADDR, VID_BUF_SIZE - ONE_COL_OFFSET);
  char* last_line = (char*)(VID_ADDR + VID_BUF_SIZE - ONE_COL_OFFSET);

  memwrite((void*)last_line, 0x0000, ONE_COL_OFFSET / 2, s_word);
}

void print_char(char c, char attr) {
  unsigned int off = get_cursor_offset();
  char* base_addr = (char*)VID_ADDR + off;
  
  int _row = _eval_offset_row(off);
  int _col = _eval_offset_col(off);


  if (_col >= MAX_COLS) {
    _row += 1;
    _col = 0;
    off = _eval_offset(_col, _row);
  }

  if (_row >= MAX_ROWS) {
    scroll();
    off = _eval_offset(0, MAX_ROWS - 1);
    _row = MAX_ROWS - 1;
    base_addr = (char*)VID_ADDR + off;
  }

  if (c == NEW_LINE_CHAR) {
    _row += 1;
    _col = 0;

    set_cursor_offset(_eval_offset(_col, _row));
    return;
  }

  *base_addr = c;
  *(base_addr + 1) = attr;
  
  set_cursor_offset(_eval_offset((_col + 1), _row));
}

int get_cursor_offset() {
  /* Use the VGA ports to get the current cursor position
   * 1. Ask for high byte of the cursor offset (data 14)
   * 2. Ask for low byte (data 15)
   */
  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8; /* High byte: << 8 */
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset += port_byte_in(REG_SCREEN_DATA);
  return offset * 2; /* Position * size of character cell */
}

void set_cursor_offset(int offset) {
  /* Similar to get_cursor_offset, but instead of reading we write data */
  offset /= 2;
  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
  port_byte_out(REG_SCREEN_CTRL, 15);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}
