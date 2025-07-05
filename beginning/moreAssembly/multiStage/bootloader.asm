use16

ORG 0x7C00

cli
xor ax, ax
mov sp, 0x7C00
mov ds, ax
mov es, ax
mov ss, ax
sti


mov ax, 0x0000
mov es, ax
mov bx, 0x8000
mov dh, 3

call disk_read


jmp 0x0000:0x8000


disk_read:

pusha
push dx

mov ah, 0x02
mov al, dh
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, 0x00
int 0x13

jc disk_read_error


pop dx
cmp al, dh
jne disk_read_error

popa
ret

disk_read_error:
pop dx
popa
mov bx, DISK_READ_ERROR_MSG
call print_string
jmp $







print_string:
mov al, [bx]
test al, al
jz _done

mov ah, 0x0e
int 0x10
inc bx
jmp print_string

_done:
ret


DISK_READ_ERROR_MSG: db "Disk Read Error...", 0



times 510-($-$$) db 0
dw 0xAA55

