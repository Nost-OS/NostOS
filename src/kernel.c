#include "kernel.h"

#include "idt/idt.h"
#include "disk/disk.h"
#include "fs/pparser.h"
#include "fs/fat/fat16.h"
#include "display/display.h"
#include "memory/heap/kheap.h"
#include "memory/paging/paging.h"

void panic(const char* msg)
{
  print(msg);
  while (1)
  {}
}

static struct paging_4gb_chunk* kernel_chunk = 0;

void kernel_main()
{
  terminal_initialize();
  print("Hello World\ntest");

  // Initialize heap
  kheap_init();

  // Initialize filesystem
  fs_init();

  // Search and initialize the disks
  disk_search_and_init();

  // Initiliaze the interrupt descriptor table
  idt_init();

  // Setup paging
  kernel_chunk = paging_new_4gb(PAGING_IS_WRITEABLE | PAGING_IS_PRESENT | PAGING_ACCESS_FROM_ALL);

  // Switch to the kernel paging chunk
  paging_switch(paging_4gb_chunk_get_directory(kernel_chunk));

  // Enable paging
  enable_paging();

  // Enable the system interrupts
  enable_interrupts();

  struct path_root* root_path = pathparser_parse("0:/bin/shell.elf");
  if (root_path) {}
}