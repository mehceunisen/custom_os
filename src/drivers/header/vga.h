#define VID_ADDR 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define ONE_ROW_OFFSET 25 * 2 // bytes
#define ONE_COL_OFFSET 80 * 2 // bytes
#define VID_BUF_SIZE 25 * 80 * 2 // bytes

#define WHITE_ON_BLACK 0x0f

//screen I/O ports for in out keywords
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

#define NEW_LINE_CHAR '\n'
void kprint(char *message);
void clear_screen();
void print_char(char c, char attr);

