#ifndef _NOSTOS_DISPLAY_H
#define _NOSTOS_DISPLAY_H

#define VGA_WIDTH 80
#define VGA_HEIGHT 20

void terminal_initialize();
void print(const char* str);

#endif