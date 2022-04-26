#pragma once

#include "../../../types.h"

typedef struct {
    char* fname;
    uint32 fkey;
    int8 perm[3];
}file;

typedef struct {
    char* path;
    uint16 table[5];
} folder;



//public fs functions
void init_fs();
void mkfile();
void mkfolder();
void rmfile();
void rmfolder();
void cd();
void rw_file();
void copy();
void paste();
void cut();
void find();

//private fs functions
void edit_table();
void set_perm();
void readf();
void writef();
