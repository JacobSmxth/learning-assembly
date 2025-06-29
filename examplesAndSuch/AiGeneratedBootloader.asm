; ============================================
; extended_boot.asm — 16-bit sandbox bootloader
; ============================================

BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax            ; DS=0x0000
    mov es, ax            ; ES=0x0000
    mov ss, ax            ; SS=0x0000
    mov sp, 0x7C00        ; SP stack at top of code
    sti

    ; -- 1. Clear screen (BIOS) -----------------
    mov ah, 0x00          ; BIOS set video mode
    mov al, 0x03          ; 80×25 text
    int 0x10

    ; -- 2. Print header (BIOS teletype) --------
    mov si, msg1
    call print_string

    ; -- 3. Direct VGA write (row 5, col 10) ----
    mov ax, 0xB800        ; VGA text buffer segment
    mov es, ax
    mov di, (5*80 + 10)*2 ; row 5, col 10
    mov byte [es:di], 'X' ; character
    mov byte [es:di+1], 0x1F ; attr: white on blue

    ; -- 4. Disk read (sector 2 → 0x0000:0x8000)-
    mov ah, 0x02          ; BIOS read sectors
    mov al, 1             ; count = 1 sector
    mov ch, 0             ; cyl 0
    mov cl, 2             ; sector 2 (LBA=1)
    mov dh, 0             ; head 0
    mov dl, [boot_drive]  ; drive number from BIOS
    mov bx, 0x8000        ; ES:BX pointer → 0x0000:0x8000
    int 0x13              ; on failure, CF=1, AH=error

    ; -- 5. Indicate disk-read result ---------
    cmp byte [boot_drive], dl ; sanity check
    jne .read_fail
    mov si, msg2
    jmp .print_and_hang

.read_fail:
    mov si, msg_fail

.print_and_hang:
    call print_string

; -- 6. Infinite halt -------------------------
hang:
    hlt
    jmp hang

; ============================================
; Utility: print_string (BIOS teletype + CRLF)
; ============================================
print_string:
    pusha
.next_char:
    lodsb
    cmp al, 0
    je .newline
    mov ah, 0x0E
    int 0x10
    jmp .next_char
.newline:
    mov al, 0x0D
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A
    mov ah, 0x0E
    int 0x10
    popa
    ret

; ============================================
; Data Section
; ============================================
boot_drive  db 0            ; filled by BIOS at start
msg1        db '*** SANDBOX BOOTLOADER v0.1 ***',0
msg2        db 'Disk read OK, proceeding...',0
msg_fail    db 'Disk read FAILED: halt.',0

; ============================================
; Padding & Signature
; ============================================
times 510 - ($ - $$) db 0
dw 0xAA55

