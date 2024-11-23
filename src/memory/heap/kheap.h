#ifndef _NOSTOS_KHEAP_H
#define _NOSTOS_KHEAP_H

#include "types.h"

#include <stdint.h>

void kheap_init();
void* kmalloc(size_t size);
void kfree(void* ptr);

#endif