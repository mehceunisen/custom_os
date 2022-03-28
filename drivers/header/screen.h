
#define VID_ADDR 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f

//screen I/O ports for in out keywords
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void kprint_at(char *message, int col, int row);
void kprint(char *message);
int print_char(char c, unsigned short col, unsigned short row, char attr);

