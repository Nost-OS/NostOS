#include "string.h"

/**
 * @brief Calculates string length then returns it
 * 
 * @param str 
 * @return size_t 
 */
size_t strlen(const char* str)
{
  size_t len = 0;
  while (str[len])
  {
    len++;
  }

  return len;
}

/**
 * @brief Calculates string length with a max lenght then returns it
 * 
 * @param str 
 * @param max 
 * @return size_t 
 */
size_t strnlen(const char* str, int max)
{
  int len = 0;
  for (len = 0; len < max; len++)
  {
    if (str[len] == 0)
    {
      break;
    }
  }

  return len;
}

bool isdigit(char c)
{
  return c >= 48 && c <= 57;
}

int tonumericaldigit(char c)
{
  if (!isdigit(c))
    return -1;

  return c - 48;
}