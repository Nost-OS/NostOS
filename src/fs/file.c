#include "file.h"

#include <types.h>
#include <config.h>
#include <status.h>
#include <kernel.h>
#include <memory/memory.h>
#include <memory/heap/kheap.h>

struct filesystem* filesystems[NOSTOS_MAX_FILESYSTEMS];
struct file_descriptor* file_descriptors[NOSTOS_MAX_FILE_DESCRIPTORS];

static struct filesystem** fs_get_free_filesystem()
{
  int i = 0;

  for (i = 0; i < NOSTOS_MAX_FILESYSTEMS; i++)
  {
    if (filesystems[i] == 0)
    {
      return &filesystems[i];
    }
  }

  return NULL;
}

static void fs_static_load()
{
  // fs_inser_filesystem(fat16_init());
}

static int file_new_descriptor(struct file_descriptor** desc_out)
{
  int res = -ENOMEM;

  for (int i = 0; i < NOSTOS_MAX_FILE_DESCRIPTORS; i++)
  {
    if (file_descriptors[i] == 0)
    {
      struct file_descriptor* desc = kzalloc(sizeof(struct file_descriptor));
      // Descriptor starts at 1
      desc->index = i + 1;
      file_descriptors[i] = desc;
      *desc_out = desc;
      res = 0;
      break;
    }
  }

  return res;
}

static struct file_descriptor* file_get_descriptor(int fd)
{
  if (fd <= 0 || fd > NOSTOS_MAX_FILE_DESCRIPTORS)
  {
    return NULL;
  }

  // Descriptors start at 1
  int index = fd - 1;
  return file_descriptors[index];
}

void fs_load()
{
  memset(filesystems, 0, sizeof(filesystems));
  fs_static_load();
}

void fs_init()
{
  memset(file_descriptors, 0, sizeof(file_descriptors));
  fs_load();
}

void fs_insert_filesystem(struct filesystem* filesystem)
{
  struct filesystem** fs;
  fs = fs_get_free_filesystem();
  if (!fs)
  {
    panic("Problem inserting filesystem");
  }

  *fs = filesystem;
}

struct filesystem* fs_resolve(struct disk* disk)
{
  struct filesystem* fs = NULL;

  for (int i = 0; i < NOSTOS_MAX_FILESYSTEMS; i++)
  {
    if (filesystems[i] != 0 && filesystems[i]->resolve(disk) == 0)
    {
      fs = filesystems[i];
      break;
    }
  }

  return fs;
}

int fopen(const char* filename, const char* mode)
{
  return -EIO;
}