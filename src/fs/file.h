#ifndef _NOSTOS_FILESYSTEM_H
#define _NOSTOS_FILESYSTEM_H

#include "pparser.h"

typedef unsigned int FILE_MODE;
typedef unsigned int FILE_SEEK_MODE;

enum
{
  SEEK_SET,
  SEEK_CUR,
  SEEK_END
};

enum
{
  FILE_MODE_READ,
  FILE_MODE_WRITE,
  FILE_MODE_APPEND,
  FILE_MODE_INVALID
};

struct disk;
typedef int (*FS_RESOLVE_FUNCTION)(struct disk* disk);
typedef void* (*FS_OPEN_FUNCTION)(struct disk* disk, struct path_part* path, FILE_MODE mode);

struct filesystem
{
  // Filesystems should return zero from resolve if the provided disk is using it's filesystem
  FS_RESOLVE_FUNCTION resolve;
  FS_OPEN_FUNCTION open;

  char name[20];
};

struct file_descriptor
{
  // The descriptor index
  int index;
  struct filesystem* filesystem;

  // Private data for internal file descriptor
  void* private;

  // The disk that the file descriptor should be on
  struct disk* disk;
};

void fs_init();
void fs_insert_filesystem(struct filesystem* filesystem);
struct filesystem* fs_resolve(struct disk* disk);
int fopen(const char* filename, const char* mode);

#endif