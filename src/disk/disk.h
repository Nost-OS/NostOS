#ifndef _NOSTOS_DISK_H
#define _NOSTOS_DISK_H

int disk_read_sector(int lba, int total, void* buf);

#endif