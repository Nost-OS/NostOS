#ifndef _NOSTOS_STATUS_H_
#define _NOSTOS_STATUS_H_

#define ERROR(value) (void*)(value)
#define ERROR_I(value) (int)(value)
#define ISERR(value) ((int)value < 0)

#define NOSTOS_ALL_OK 0
#define EIO 1
#define EINVARG 2
#define ENOMEM 3
#define EBADPATH 4
#define EFSNOTUS 5

#endif