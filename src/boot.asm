ORG 0
[BITS 16]

_start:
  jmp short start
  nop

times 33 db 0

start:
  jmp 0x7c0:boot

boot:
  ; Handling interrupts
  cli ; Clear Interrupts
  mov ax, 0x7c0
  mov ds, ax ; Data Segment
  mov es, ax ; Extra Segment
  mov ax, 0x00
  mov ss, ax ; Stack Segment
  mov sp, 0x7c00
  sti ; Enable Interrupts

  ; Start read from disk
  mov ah, 2 ; Read Sector Command
  mov al, 1 ; Read one sector
  mov ch, 0 ; Cylinder low 8 bits
  mov cl, 2 ; Read sector 2
  mov dh, 0 ; Head number
  mov bx, buffer
  int 0x13
  jc error
  ; End read from disk

  mov si, buffer
  call print

  jmp $

error:
  mov si, disk_error
  call print
  jmp $

print:
  mov bx, 0
.loop:
  lodsb
  cmp al, 0
  je .done
  call print_char
  jmp .loop
.done:
  ret

print_char:
  mov ah, 0eh
  int 0x10
  ret

disk_error: db 'Failed to load sector', 0

times 510-($ - $$) db 0
dw 0xAA55

buffer: