;; Type a word thing


format binary as 'iso'

use16

ORG 0x7C00

_setseg:
  xor ax, ax
  mov ss, ax
  mov sp, 0x7C00
  mov ax, 0x0000
  mov ds, ax
  mov es, ax

push 0
push _start
retf



_start:
  mov ah, 0x0
  int 0x10

  ;mov ah, 0x0e
  ;mov al, 'H'
  ;int 0x10

  ;mov ah, 0x0e
  ;mov al, 'e'
  ;int 0x10


_printLoop:
  mov ah, 0x0
  int 0x16
  cmp al, 27
  jz _haltLoop

  mov ah, 0x0e
  int 0x10
  add bx, 1
  jmp _printLoop



_haltLoop:
  jmp $








times 510-($-$$)  db 0
dw 0xAA55
