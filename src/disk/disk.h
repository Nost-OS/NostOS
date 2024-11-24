#ifndef _NOSTOS_DISK_H
#define _NOSTOS_DISK_H

typedef unsigned int NOSTOS_DISK_TYPE;

// Represents a real physical disk
#define NOSTOS_DISK_TYPE_REAL 0

struct disk
{
  NOSTOS_DISK_TYPE type;
  int sector_size;
};

void disk_search_and_init();
struct disk* get_disk(int index);
int disk_read_block(struct disk* idisk, unsigned int lba, int total, void* buf);

#endif