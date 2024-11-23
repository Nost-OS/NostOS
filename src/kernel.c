#include "kernel.h"

#include "idt/idt.h"
#include "display/display.h"
#include "memory/heap/kheap.h"

void panic(const char* msg)
{
  print(msg);
  while (1)
  {}
}

void kernel_main()
{
  terminal_initialize();
  print("Hello World\ntest");

  // Initialize heap
  kheap_init();

  // Initiliaze the interrupt descriptor table
  idt_init();

  // Enable the system interrupts
  enable_interrupts();
}