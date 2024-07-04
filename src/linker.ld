ENTRY(_start)
OUTPUT_FORMAT(binary)

phys = 0x100000;

/*
 * Tell where the various sections of the object files will be put in the
 * final kernel image
*/
SECTIONS
{
  /*
   * Begin putting sections at 1MiB, a conventional place for kernels to be
   * loaded in by the bootloader
  */
  . = 1M;
  .text : ALIGN(4096)
  {
    *(.text)
  }

  .asm : ALIGN(4096)
  {
    *(.asm)
  }

  .rodata : ALIGN(4096)
  {
    *(.rodata)
  }

  .data : ALIGN(4096)
  {
    *(.data)
  }

  .bss : ALIGN(4096)
  {
    *(COMMON)
    *(.bss)
  }
}