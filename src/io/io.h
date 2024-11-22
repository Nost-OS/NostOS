#ifndef _NOSTOS_IO_H
#define _NOSTOS_IO_H

unsigned char insb(unsigned short port);
unsigned short insw(unsigned short port);

void outb(unsigned short port, unsigned char data);
void outw(unsigned short potr, unsigned short data);

#endif