#include "idt.h"

#include <kernel.h>
#include <config.h>
#include <io/io.h>
#include <memory/memory.h>
#include <display/display.h>

#define IDT_GATE_TYPE_ATTR 0xEE

extern void int21h();
extern void no_interrupt();
extern void idt_load(struct idtr_desc* ptr);

struct idtr_desc idtr_descriptor;
struct idt_desc idt_descriptors[NOSTOS_TOTAL_INTERRUPTS];

void isr0_handler()
{
  panic("\nDivide by zero error!\n");
}

void int21_handler()
{
  print("Keyboard pressed!\n");
  outb(0x20, 0x20);
  outb(0xA0, 0x20);
}

void no_interrupt_handler()
{
  outb(0x20, 0x20);
}

void idt_set(int interrupt_no, void* address)
{
  struct idt_desc* desc = &idt_descriptors[interrupt_no];
  desc->offset_1 = (uint32_t)address & 0x0000ffff;
  desc->selector = KERNEL_CODE_SELECTOR;
  desc->zero = 0x00;
  desc->type_attr = IDT_GATE_TYPE_ATTR;
  desc->offset_2 = (uint32_t)address >> 16;
}

void idt_init()
{
  memset(idt_descriptors, 0, sizeof(idt_descriptors));
  idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
  idtr_descriptor.base = (uint32_t)idt_descriptors;

  for (int i = 0; i < NOSTOS_TOTAL_INTERRUPTS; i++)
  {
    idt_set(i, no_interrupt);
  }

  idt_set(0, isr0_handler);
  idt_set(0x21, int21h);

  // Load the interrupt descriptor table
  idt_load(&idtr_descriptor);
}