;;


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

  mov ah, 0x0
  int 0x16


  mov ah, 0x0e
  int 0x10




_haltLoop:
  jmp $



  ; push 30
  ; call _printNumber

  ; _printNumber
  ; push bx
  ; mov bx, sp
  ; add bx, 2
  ; mov ax, [bx]
  ;
  ; pop bx
  ;
  ; ret 2









times 510-($-$$)  db 0
dw 0xAA55
