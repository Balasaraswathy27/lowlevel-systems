BITS 16           ; 16-bit code for BIOS
ORG 0x7C00        ; BIOS loads boot sector here

start:
    xor cx, cx          ; length counter = 0
    mov di, buffer      ; DI points to buffer

read_loop:
    mov ah, 0x00
    int 0x16            ; wait for key, AL = ASCII

    cmp ah,0x01
    je hang

    cmp al, 0x08       ; backspace pressed?
    je backspace

    stosb               ; store AL in buffer[DI], DI++
    inc cx              ; increment length counter

    mov ah, 0x0E
    int 0x10            ; echo character
    jmp read_loop

backspace:
    cmp cx,0
    je read_loop
    mov ah,0x0E
    mov al,0x08
    int 0x10
    mov al,' '
    int 0x10
    mov al,0x08
    int 0x10
    dec cx
    dec di
    jmp read_loop
hang:
        jmp $

buffer db 32 dup(0)
TIMES 510-($-$$) db 0  ; pad to 510 bytes
DW 0xAA55              ; boot signature
