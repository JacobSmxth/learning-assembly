
format binary as 'iso'

use16

ORG 0x7C00

_setseg:
xor ax, ax              ; Zero AX by xoring it to itself
mov ss, ax              ; Sets SS to 0x0000
mov sp, 0x7C00          ; Sets SP to 0x7C00, Just below loader
mov ds, ax              ; Resets DS to 0x0000
mov es, ax              ; Resets ES to 0x0000
jmp 0x0000:_start       ; Far jumps to _start

_start:
mov ah, 0x0             ;  Set to Video Mode
int 0x10                ;  -------------------------

mov bx, NewMsg          ; Places NewMsg data into bx, a general register
call PrintString        ; Pushes return address onto stack and jumps into PrintString

mov bx, AnotherMsg      ; Updates bx to new data in AnotherMsg
call PrintString        ; Pushes return address onto stack and jumps into PrintString



_loopWrite:             ; The start of new loop to start typing
mov ah, 0x0             ; Set to video mode
int 0x16                ; Start reading keyborad character inputs

cmp al, 27              ; Check if escape button clicked
jz _halt                ; If clicked stop

cmp al, 8               ; Check for backspace press
je _doBackspace         ; Run backspace

cmp al, 13              ; If enter is pressed
je _doEnter             ; Run enter

mov ah, 0x0e            ; Teletype
int 0x10
jmp _loopWrite          ; Back to top to loop



_doEnter:
mov ah, 0x0e            ; Teletype
mov al, 0x0d            ; Carriage Return
int 0x10
mov al, 0x0a            ; Set column to 0
int 0x10
jmp _loopWrite          ; Back to loop


_doBackspace:
mov ah, 0x0e            ; Teletype
mov al, 8               ; Move cursor left
int 0x10
mov al, ' '             ; set character to ' ' (space/empty)
int 0x10
mov al, 8               ; Move cursor left
int 0x10
jmp _loopWrite          ; Back to loop



_halt:                  ; Final Idle state
jmp $                   ; Infinite halt



PrintString:            ; My print string ""Function""
_repeat:                ; Repeat label to loop through string
mov al, [bx]            ; Gets the current character from the bx and prepares for comparison and print
cmp al, 0               ; Compares al to 0 (null terminator). So we don't go off the rails and start showing random bits
jz _done                ; If null terminator is reached we jump to the done to avoid more iterations
mov ah, 0x0e            ; TeleType interrupt
int 0x10                ; Video interrupt
inc bx                  ; increment bx up by 1
jmp _repeat             ; Repeat the loop

_done:                  ; signifies the completion of the loop
ret                     ; Pops the saved pointer from the stack, return back to the caller


NewMsg:                 ; Defines the first message (Uses 0x0D to reset cursor to column 1, and 0x0A to move to next line)
 db "New Message Inputed.", 0x0D, 0x0A, 0


AnotherMsg:             ; Defines the second message (Uses 0x0D to reset cursor to column 1, and 0x0A to move to next line)
db "Second Message Here!", 0x0D, 0x0A, 0


times 510-($-$$) db 0   ; (IDK)
dw 0xAA55               ; Boot Signature
