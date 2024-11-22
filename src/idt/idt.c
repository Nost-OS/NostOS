#include "idt.h"

#include <config.h>
#include <memory/memory.h>
#include <kernel.h>

#define IDT_GATE_TYPE_ATTR 0xEE

extern void idt_load(struct idtr_desc* ptr);

struct idtr_desc idtr_descriptor;
struct idt_desc idt_descriptors[NOSTOS_TOTAL_INTERRUPTS];

void isr0_handler()
{
  panic("\nDivide by zero error!\n");
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

  idt_set(0, isr0_handler);

  // Load the interrupt descriptor table
  idt_load(&idtr_descriptor);
}