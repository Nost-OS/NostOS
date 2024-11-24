#include "disk.h"

#include <config.h>
#include <status.h>
#include <io/io.h>
#include <memory/memory.h>

struct disk disk;

#define ATA_PRIMARY_IO 0x1F0

// ATA register offsets
#define ATA_REG_DATA 0x00
#define ATA_REG_ERROR 0x01
#define ATA_REG_SECTORS 0x02
#define ATA_REG_LBA_L0 0x03
#define ATA_REG_LBA_MID 0x04
#define ATA_REG_LBA_HI 0x05
#define ATA_REG_DEVICE 0x06
#define ATA_REG_STATUS 0x07
#define ATA_REG_COMMAND 0x07

// ATA commands
#define ATA_CMD_READ_PIO 0x20

// ATA Status register bits
#define ATA_SR_BSY 0x80
#define ATA_SR_DRQ 0x08

int disk_read_sector(int lba, int total, void* buf)
{
  outb(ATA_PRIMARY_IO + ATA_REG_DEVICE, (lba >> 24) | 0xE0);
  outb(ATA_PRIMARY_IO + ATA_REG_SECTORS, total);
  outb(ATA_PRIMARY_IO + ATA_REG_LBA_L0, (unsigned char)(lba & 0xff));
  outb(ATA_PRIMARY_IO + ATA_REG_LBA_MID, (unsigned char)(lba >> 8));
  outb(ATA_PRIMARY_IO + ATA_REG_LBA_HI, (unsigned char)(lba >> 16));
  outb(ATA_PRIMARY_IO + ATA_REG_COMMAND, ATA_CMD_READ_PIO);

  unsigned short* ptr = (unsigned short*)buf;

  for (int b = 0; b < total; b++)
  {
    // Wait for the buffer to be ready
    unsigned short status_port = ATA_PRIMARY_IO + ATA_REG_STATUS;
    char c = insb(status_port);
    while ((c & ATA_SR_BSY) && !(c & ATA_SR_DRQ))
    {
      c = insb(status_port);
    }

    // Copy from hard disk to memory
    for (int i = 0; i < 256; i++)
    {
      *ptr = insw(ATA_PRIMARY_IO + ATA_REG_DATA);
      ptr++;
    }
  }

  return 0;
}

void disk_search_and_init()
{
  memset(&disk, 0, sizeof(disk));
  disk.id = 0;
  disk.type = NOSTOS_DISK_TYPE_REAL;
  disk.sector_size = NOSTOS_SECTOR_SIZE;
}

struct disk* disk_get(int index)
{
  if (index != 0)
    return 0;

  return &disk;
}

int disk_read_block(struct disk* idisk, unsigned int lba, int total, void* buf)
{
  if (idisk != &disk)
  {
    return -EIO;
  }

  return disk_read_sector(lba, total, buf);
}