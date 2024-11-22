#include "io.h"

unsigned char insb(unsigned short port)
{
  unsigned char rv;
  __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (port));
  return rv;
}

unsigned short insw(unsigned short port)
{
  unsigned short rv;
  __asm__ __volatile__ ("inw %1, %0" : "=a" (rv) : "dN" (port));
  return rv;
}

void outb(unsigned short port, unsigned char data)
{
  __asm__ __volatile__ ("outb %1, %0" : : "dN" (port), "a" (data) : "memory");
}

void outw(unsigned short port, unsigned short data)
{
  __asm__ __volatile__ ("outw %1, %0" : : "dN" (port), "a" (data) : "memory");
}