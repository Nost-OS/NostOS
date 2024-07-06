#include "kernel.h"

#include "display/display.h"

void kernel_main()
{
  terminal_initialize();
  print("Hello World\ntest");
}