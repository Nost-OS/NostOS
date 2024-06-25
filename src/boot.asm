[ORG 0x7c00]
[BITS 16]

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
  jmp short start
  nop

times 33 db 0

start:
  jmp 0x7c0:boot

boot:
  ; Handling interrupts
  cli ; Clear Interrupts
  mov ax, 0x00
  mov ds, ax ; Data Segment
  mov es, ax ; Extra Segment
  mov ss, ax ; Stack Segment
  mov sp, 0x7c00
  sti ; Enable Interrupts

.load_protected:
  cli
  lgdt [gdt_descriptor]
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax
  jmp CODE_SEG:load32

; GDT (Global Descriptor Table)
gdt_start:

gdt_null:
  dd 0x0  ; Null Segment
  dd 0x0

; offset 0x8
gdt_code:       ; CS SHOULD POINT TO THIS
  dw 0xffff     ; Segmenent limit first 0-15 bits
  dw 0          ; Base first 0-15 bits
  db 0          ; Base 16-31 bits
  db 0x9a       ; Access byte
  db 11001111b  ; High 4 bits flags and low 4 bits flags
  db 0          ; Base 24-31 bits

; offset 0x10
gdt_data:       ; DS, SS, ES, FS, GS
  dw 0xffff     ; Segmenent limit first 0-15 bits
  dw 0          ; Base first 0-15 bits
  db 0          ; Base 16-31 bits
  db 0x92       ; Access byte
  db 11001111b  ; High 4 bits flags and low 4 bits flags
  db 0          ; Base 24-31 bits

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start-1  ; GDT limit (size - 1)
  dd gdt_start              ; GDT base address

[BITS 32]
load32:
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  mov ebp, 0x00200000
  mov esp, ebp
  jmp $

times 510-($ - $$) db 0
dw 0xAA55