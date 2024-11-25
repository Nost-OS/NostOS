#ifndef _NOSTOS_STRING_H
#define _NOSTOS_STRING_H

#include <types.h>

#include <stdbool.h>

size_t strlen(const char* str);
size_t strnlen(const char* str, int max);
char* strcpy(char* dest, const char* src);
bool isdigit(char c);
int tonumericaldigit(char c);

#endif