#include "kernel.h"

#include "idt/idt.h"
#include "display/display.h"

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

  // Initiliaze the interrupt descriptor table
  idt_init();
}