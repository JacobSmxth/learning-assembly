
format binary as 'iso'

use16

ORG 0x7C00

xor ax, ax
mov ss, ax
mov sp, 0x7C00
mov ds, ax
mov es, ax
jmp _start


_start:
mov ah, 0x0
int 0x10


mov bx, Prompt
call PrintLoop

UserBuffer: times 32 db 0
mov si, UserBuffer

_writeLoop:
mov ah, 0x0
int 0x16

cmp al, 13
je _endLoop

cmp al, 8
je _doBackspace

cmp al, 27
je _halt


mov ah, 0x0e
int 0x10
mov [si], al
inc si
jmp _writeLoop


_doBackspace:
mov ah, 0x0e
mov al, 0x08
int 0x10
mov ah, 0x0e
mov al, ' '
int 0x10
mov ah, 0x0e
mov al, 0x08
int 0x10
dec si
jmp _writeLoop


_endLoop:
mov ah, 0x0e
mov al, 0x0d
int 0x10
mov ah, 0x0e
mov al, 0x0a
int 0x10
mov bx, Hello
call PrintLoop

mov bx, UserBuffer
call PrintLoop

mov ah, 0x0e
mov al, '!'
int 0x10



_halt:
jmp $



PrintLoop:
mov al, [bx]
cmp al, 0
jz _done

mov ah, 0x0e
int 0x10
inc bx
jmp PrintLoop

_done:
ret



Prompt: db "Please Enter Your Name: ", 0
Hello: db "Hello, ", 0


times 510-($-$$) db 0
dw 0xAA55
