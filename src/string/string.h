#ifndef _NOSTOS_STRING_H
#define _NOSTOS_STRING_H

#include <types.h>

#include <stdbool.h>

size_t strlen(const char* str);
size_t strnlen(const char* str, int max);
int strlen_terminator(const char* str, int max, char terminator);
char* strcpy(char* dest, const char* src);
int strncmp(const char* str1, const char* str2, int n);
int istrncmp(const char* str1, const char* str2, int n);
bool isdigit(char c);
int tonumericaldigit(char c);
char tolower(char c);

#endif