OUTPUT_FORMAT(elf64)
ENTRY(_start)

SECTIONS
{
    . = 0x7e00;
    _KernelStart = .;
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .rodata : {
        *(.rodata)
    }
    .bss : {
        *(COMMON)
        *(.bss)
    }
    _KernelEnd = .;
}
