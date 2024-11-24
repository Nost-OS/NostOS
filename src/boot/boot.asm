[ORG 0x7c00]
[BITS 16]

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
  jmp short start
  nop

times 33 db 0

start:
  jmp 0:boot

boot:
  ; Handling interrupts
  cli ; Clear Interrupts
  mov ax, 0x00
  mov ds, ax ; Data Segment
  mov es, ax ; Extra Segment
  mov ss, ax ; Stack Segment
  mov gs, ax
  mov fs, ax

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
  dw 0xffff     ; Segment limit first 0-15 bits
  dw 0          ; Base first 0-15 bits
  db 0          ; Base 16-23 bits
  db 0x9a       ; Access byte
  db 11001111b  ; High 4 bits flags and low 4 bits flags
  db 0          ; Base 24-31 bits

; offset 0x10
gdt_data:       ; DS, SS, ES, FS, GS
  dw 0xffff     ; Segment limit first 0-15 bits
  dw 0          ; Base first 0-15 bits
  db 0          ; Base 16-23 bits
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
  mov es, ax
  mov ds, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  ; Enable the A20 line
  in al, 0x92
  or al, 2
  out 0x92, al

  mov eax, 1
  mov ecx, 100
  mov edi, 0x0100000
  
  call ata_lba_read
  jmp CODE_SEG:0x0100000

ata_lba_read:
  mov ebx, eax ; Backup the LBA
  ; Send the highest 8 bits of the lba to the hard disk controller
  shr eax, 24
  or eax, 0xE0 ; Select the master drive
  mov dx, 0x1F6
  out dx, al
  ; Finished sending the highest 8 bits of the lba

  ; Send the total sectors to read
  mov eax, ecx
  mov dx, 0x1F2
  out dx, al
  ; Finsished sending the total sectors to read

  ; Send more bits to the LBA
  mov eax, ebx ; Restore the backup LBA
  mov dx, 0x1F3
  out dx, al
  ; Finished sending more bits to the LBA

  ; Send more bits to the LBA
  mov dx, 0x1F4
  mov eax, ebx ; Restore the backup LBA
  shr eax, 8
  out dx, al
  ; Finished sending more bits of the LBA

  ; Send upper 16 bits of the LBA
  mov dx, 0x1F5
  mov eax, ebx ; Restore backup LBA
  shr eax, 16
  out dx, al
  ; Finished sending upper 16 bits of the LBA

  mov dx, 0x1F7
  mov al, 0x20
  out dx, al

; Read all sectors into memory
.next_sector:
  push ecx

; Checking if we need to read
.try_again:
  mov dx, 0x1F7
  in al, dx
  test al, 8
  jz .try_again

  ; We need to read 256 words at a time
  mov ecx, 256
  mov dx, 0x1F0
  rep insw
  pop ecx
  loop .next_sector
  ; End of reading sectors into memory
  ret

times 510-($ - $$) db 0
dw 0xAA55