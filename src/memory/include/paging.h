#pragma once
#include <types.h>

typedef uint64_t paging_desc_t;

typedef struct {
  uint16_t pml4;   // index to top level pml4
  uint16_t pdpt;   // index to next level PDPT
  uint16_t pd;     // index to page directory
  uint16_t pt;     // index to page table
  uint16_t offset; // address offset
} paging_indexer_t;

typedef struct {
  paging_desc_t entries[512]; 
} PAGING_PAGE_ALIGNED page_directory_t;
