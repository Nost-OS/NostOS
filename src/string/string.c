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

/**
 * @brief Calculates length of a string until it find a user terminator or the null terminator
 * 
 * @param str 
 * @param max 
 * @param terminator 
 * @return int 
 */
int strlen_terminator(const char* str, int max, char terminator)
{
  int i = 0;
  for (i = 0; i < max; i++)
  {
    if (str[i] == '\0' || str[i] == terminator)
      break;
  }

  return i;
}

/**
 * @brief Copies string from source to destination and adds null termination at end of dest
 * 
 * @param dest 
 * @param src 
 * @return char* 
 */
char* strcpy(char* dest, const char* src)
{
  char* res = dest;

  while (*src != 0)
  {
    *dest = *src;
    src += 1;
    dest += 1;
  }

  *dest = 0x00;
  
  return res;
}

/**
 * @brief Compares two string with a max length
 * 
 * @param str1 
 * @param str2 
 * @param n 
 * @return int 
 */
int strncmp(const char* str1, const char* str2, int n)
{
  unsigned char u1, u2;

  while (n-- > 0)
  {
    u1 = (unsigned char)*str1++;
    u2 = (unsigned char)*str2++;
    
    if (u1 != u2)
      return u1 - u2;

    if (u1 == '\0')
      return 0;
  }

  return 0;
}

/**
 * @brief Compares two string with a max length but case unsensitive
 * 
 * @param str1 
 * @param str2 
 * @param n 
 * @return int 
 */
int istrncmp(const char* str1, const char* str2, int n)
{
  unsigned char u1, u2;

  while (n-- > 0)
  {
    u1 = (unsigned)*str1++;
    u2 = (unsigned)*str2++;

    if (u1 != u2 && tolower(u1) != tolower(u2))
      return u1 - u2;

    if (u1 == '\0')
      return 0;
  }

  return 0;
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

char tolower(char c)
{
  if (c >= 65 && c <= 80)
  {
    c += 32;
  }

  return c;
}