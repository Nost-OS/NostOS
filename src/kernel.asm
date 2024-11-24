[BITS 32]

global _start

extern kernel_main

CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  mov ebp, 0x00200000
  mov esp, ebp

  ; Disable interrupts
  cli

  call setup_pic

  call kernel_main

  jmp $

setup_pic:
  ; Remap the master PIC
  mov al, 00010001b
  out 0x20, al ; Tell master PIC

  mov al, 0x20 ; Interrupt 0x20 in where the master PIC should start
  out 0x21, al

  mov al, 00000001b
  out 0x21, al
  ; End remap of the master PIC

  ; Remap the slave PIC
  mov al, 00010001b
  out 0xA0, al

  mov al, 0x28
  out 0xA1, al

  ; Tell the master PIC about the slave PIC
  mov al, 00000100b
  out 0x21, al
  mov al, 00000010b
  out 0xA1, al

  ; Set PICS to 8086 mode
  mov al, 00000001b
  out 0x21, al
  out 0xA1, al

  ret

times 512-($ - $$) db 0