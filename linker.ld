OUTPUT_FORMAT(elf64)
ENTRY(_start)

SECTIONS
{
	_KernelStart = .;
	.text : ALIGN(0x1200)
	{
		*(.text)
	}
	.data : ALIGN(0x1200)
	{
		*(.data)
	}
	.rodata : ALIGN(0x1200)
	{
		*(.rodata)
	}
	.bss : ALIGN(0x1200)
	{
		*(COMMON)
		*(.bss)
	}
	_KernelEnd = .;
}