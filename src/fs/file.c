#include "file.h"
#include "fat/fat16.h"

#include <types.h>
#include <config.h>
#include <status.h>
#include <kernel.h>
#include <disk/disk.h>
#include <string/string.h>
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
  fs_insert_filesystem(fat16_init());
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

FILE_MODE file_get_mode_by_string(const char* str)
{
  FILE_MODE mode = FILE_MODE_INVALID;

  if (strncmp(str, "r", 1) == 0)
  {
    mode = FILE_MODE_READ;
  }
  else if (strncmp(str, "w", 1) == 0)
  {
    mode = FILE_MODE_READ;
  }
  else if (strncmp(str, "a", 1) == 0)
  {
    mode = FILE_MODE_APPEND;
  }

  return mode;
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

int fopen(const char* filename, const char* mode_str)
{
  int res = 0;
  struct disk* disk = NULL;
  FILE_MODE mode = FILE_MODE_INVALID;
  void* descriptor_private_data = NULL;
  struct file_descriptor* desc = NULL;

  struct path_root* root_path = pathparser_parse(filename);
  if (!root_path)
  {
    res = -EINVARG;
    goto out;
  }

  // We cannot just have a root path
  if (!root_path->first)
  {
    res = -EINVARG;
    goto out;
  }

  // Ensure that the disk we are reading from exists
  disk = disk_get(root_path->drive_no);
  if (!disk)
  {
    res = -EIO;
    goto out;
  }

  if (!disk->filesystem)
  {
    res = -EIO;
    goto out;
  }

  mode = file_get_mode_by_string(mode_str);
  if (mode == FILE_MODE_INVALID)
  {
    res = -EINVARG;
    goto out;
  }

  descriptor_private_data = disk->filesystem->open(disk, root_path->first, mode);
  if (ISERR(descriptor_private_data))
  {
    res = ERROR_I(descriptor_private_data);
    goto out;
  }

  res = file_new_descriptor(&desc);
  if (res < 0)
  {
    goto out;
  }

  desc->filesystem = disk->filesystem;
  desc->private = descriptor_private_data;
  desc->disk = disk;
  res = desc->index;

out:
  if (res < 0)
  {
    // Error
    if (root_path)
    {
      pathparser_free(root_path);
      root_path = NULL;
    }

    if (disk && descriptor_private_data)
    {
      // disk->filesystem->close(descriptor_private_data);
      descriptor_private_data = NULL;
    }

    if (desc)
    {
      // file_free_descriptor(desc);
      desc = NULL;
    }

    // fopen shouldn't return negative values
    res = 0;
  }

  return res;
}