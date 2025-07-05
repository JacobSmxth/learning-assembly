use16
ORG 0x8000


_start:
jmp _menu

_menu:
mov si, UserBuffer
mov cx, 32
_clearBuffer:
mov byte [si], 0
inc si
loop _clearBuffer
call ClearScreen


mov bx, MenuOne
call PrintLoop

mov bx, MenuTwo
call PrintLoop

mov bx, MenuThree
call PrintLoop


_askInput:
mov bx, MenuPrompt
call PrintLoop


_inputLoop:
mov ah, 0x0
int 0x16

mov ah, 0x0e
int 0x10

cmp al, 49
jz _askName

cmp al, 50
jz _hardcodedInfo

cmp al, 51
jz _halt

mov ah, 0x0
jmp _inputLoop

_askName:
call ClearScreen
mov ah, 0x0e
mov al, 0x0d
int 0x10
mov ah, 0x0e
mov al, 0x0a
int 0x10

mov bx, Prompt
call PrintLoop

mov si, UserBuffer

_writeName:
mov ah, 0x0
int 0x16

cmp al, 13
je _endLoop

cmp al, 8
je _doBackspace

cmp al, 27
je _endLoop


mov ah, 0x0e
int 0x10
mov [si], al
inc si
jmp _writeName


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
jmp _writeName


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

mov ah, 0x0e
mov al, 0x0d
int 0x10
mov ah, 0x0e
mov al, 0x0a
int 0x10

call PauseScreen
jmp _menu

_hardcodedInfo:
call ClearScreen
mov ah, 0x0e
mov al, 0x0d
int 0x10
mov ah, 0x0e
mov al, 0x0a
int 0x10
mov bx, HardCoded
call PrintLoop
call PauseScreen
jmp _menu


_halt:
call ClearScreen
mov ah, 0x0e
mov al, 0x0d
int 0x10
mov ah, 0x0e
mov al, 0x0d
int 0x10
mov bx, HaltMsg
call PrintLoop
jmp $


PrintLoop:
mov al, [bx]
test al, al
jz _done

mov ah, 0x0e
int 0x10
inc bx
jmp PrintLoop

_done:
ret


ClearScreen:
mov ah, 0x06
mov al, 0
mov bh, 0x07
mov cx, 0
mov dx, 0x184f
int 0x10
ret


PauseScreen:
mov bx, Continue
call PrintLoop
mov ah, 0x0
int 0x16
ret




UserBuffer: times 32 db 0

; Hard Coded Texts
MenuOne: db "1. Enter Name", 0x0d, 0x0a, 0
MenuTwo: db "2. Show Hardcoded Info", 0x0d, 0x0a, 0
MenuThree: db "3. Halt System", 0x0d, 0x0a, 0
MenuPrompt: db "Enter Selection: ", 0
HardCoded: db "This is the Assembly Bootloader v1.0", 0x0d, 0x0a, 0
Prompt: db "Please Enter Your Name: ", 0
Continue: db "Press any key to continue", 0
Hello: db "Hello, ", 0

; Halting Texts
HaltMsg: db "Halting system...", 0

