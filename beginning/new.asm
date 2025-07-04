
format binary as 'iso'

use16

org 0x7C00

xor ax, ax
mov ss, ax
mov sp, 0x7C00
mov es, ax
mov ds, ax
jmp _start

_start:
mov ah, 0x0
int 0x10

mov bx, NewMSG

_printLoop:
mov al, [bx]
cmp al, 0
jz _halt

mov ah, 0x0e
int 0x10
inc bx
jmp _printLoop



_halt:
jmp $


NewMSG:
db "Hello, World!"

times 510-($-$$) db 0
dw 0xAA55
