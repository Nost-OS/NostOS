#ifndef _NOSTOS_DISK_H
#define _NOSTOS_DISK_H

#include <fs/file.h>

typedef unsigned int NOSTOS_DISK_TYPE;

// Represents a real physical disk
#define NOSTOS_DISK_TYPE_REAL 0

struct disk
{
  NOSTOS_DISK_TYPE type;
  int sector_size;

  // The id of the disk
  unsigned int id;

  struct filesystem* filesystem;

  // The private data of out filesystem
  void* fs_private;
};

void disk_search_and_init();
struct disk* disk_get(int index);
int disk_read_block(struct disk* idisk, unsigned int lba, int total, void* buf);

#endif