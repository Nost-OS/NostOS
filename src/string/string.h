#ifndef _NOSTOS_STRING_H
#define _NOSTOS_STRING_H

#include <types.h>

#include <stdbool.h>

size_t strlen(const char* str);
size_t strnlen(const char* str, int max);
bool isdigit(char c);
int tonumericaldigit(char c);

#endif