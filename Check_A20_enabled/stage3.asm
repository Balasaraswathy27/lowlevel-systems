BITS 16
ORG 0x9000

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9C00
    sti

    call CheckA20

    ; ---- print AX (0 or 1) ----
    add al, '0'        ; convert 0/1 to ASCII
    mov ah, 0x0E
    int 0x10

hang:
    hlt
    jmp hang

; ===============================
; Check A20
; AX = 0 → disabled
; AX = 1 → enabled
; ===============================
CheckA20:
    cli

    xor ax, ax
    mov es, ax          ; ES = 0x0000

    not ax
    mov ds, ax          ; DS = 0xFFFF

    mov di, 0x0500
    mov si, 0x0510

    ; save original bytes
    mov al, [es:di]
    push ax
    mov al, [ds:si]
    push ax

    ; write test values
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF

    ; check overwrite
    cmp byte [es:di], 0xFF

    ; restore memory
    pop ax
    mov [ds:si], al
    pop ax
    mov [es:di], al

    mov ax, 0           ; assume A20 OFF
    je .done
    mov ax, 1           ; A20 ON

.done:
    sti
    ret
