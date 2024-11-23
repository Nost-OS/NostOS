section .asm

extern int21_handler
extern no_interrupt_handler

global enable_interrupts
global disable_interrupts

global idt_load
global int21h
global no_interrupt

enable_interrupts:
  sti
  ret

disable_interrupts:
  cli
  ret

idt_load:
  push ebp
  mov ebp, esp
  mov ebx, [ebp+8]
  lidt [ebx]
  pop ebp
  ret

int21h:
  pushad
  cli
  call int21_handler
  sti
  popad
  iret

no_interrupt:
  pushad
  cli
  call no_interrupt_handler
  sti
  popad
  iret