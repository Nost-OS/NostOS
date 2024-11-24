#ifndef _NOSTOS_MEMORY_H
#define _NOSTOS_MEMORY_H

#include <types.h>

void* memset(void* ptr, int c, size_t size);
int memcmp(void* s1, void* s2, int count);

#endif