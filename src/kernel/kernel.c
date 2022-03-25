int main()
{
    char *vid_mem = (char *)0xb8000;
    *vid_mem = 'X';
    return 0;
}
