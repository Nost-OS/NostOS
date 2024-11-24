#ifndef _NOSTOS_CONFIG_H
#define _NOSTOS_CONFIG_H

#define KERNEL_CODE_SELECTOR 0x08
#define KERNEL_DATA_SELECTOR 0x10

#define NOSTOS_TOTAL_INTERRUPTS 512

// 100MB heap size
#define NOSTOS_HEAP_SIZE_BYTES 104857600
#define NOSTOS_HEAP_BLOCK_SIZE 4096
#define NOSTOS_HEAP_ADDRESS 0x01000000
#define NOSTOS_HEAP_TABLE_ADDRESS 0x00007E00

// Disk configuration
#define NOSTOS_SECTOR_SIZE 512

#endif