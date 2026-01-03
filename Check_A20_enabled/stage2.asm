BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Print message
    mov si, msg
.print:
    lodsb
    or al, al
    jz load_stage2
    mov ah, 0x0E
    int 0x10
    jmp .print

load_stage2:
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x8000

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x00
    int 0x13
    jc disk_error

    jmp 0x0000:0x8000

disk_error:
    hlt
    jmp $

msg db "Loading stage 2...", 0

times 510-($-$$) db 0
dw 0xAA55
