OUTPUT_FORMAT(elf64)
ENTRY(_start)

SECTIONS
{
	_KernelStart = .;
	.text : ALIGN(0x7e00)
	{
		*(.text)
	}
	.data : ALIGN(0x7e00)
	{
		*(.data)
	}
	.rodata : ALIGN(0x7e00)
	{
		*(.rodata)
	}
	.bss : ALIGN(0x7e00)
	{
		*(COMMON)
		*(.bss)
	}
	_KernelEnd = .;
}