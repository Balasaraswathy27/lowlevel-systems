BITS 16
ORG 0x8000

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9C00
    sti

    mov si, msg
.print:
    lodsb
    or al, al
    jz load_kernel
    mov ah, 0x0E
    int 0x10
    jmp .print

load_kernel:
 mov ax, 0x0000
    mov es, ax
    mov bx, 0x9000        ; Load address of kernel

    mov ah, 0x02          ; BIOS function: read sectors
    mov al, 5             ; Number of sectors to read
    mov ch, 0             ; Cylinder
    mov cl, 3             ; Sector 2
    mov dh, 0             ; Head
    mov dl, 0x00          ; Drive 0 (floppy or HDD)
    int 0x13              ; BIOS interrupt

    jmp 0x0000:0x9000     ; Jump to loaded kernel
hang:
    hlt
    jmp $

msg db "Stage 2 running!", 0
