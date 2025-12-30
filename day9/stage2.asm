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
	mov si,msg

.print:

	lodsb
	or al,al
	jz e820_start
	mov ah,0x0E
	int 0x10
	jmp .print

e820_start:

	xor ebx,ebx
        mov di,e820_buf
        xor cx,cx
do_e820:
	
        mov eax, 0xE820
        mov edx, 0x534D4150    ; 'SMAP'
        mov ecx, 24

        int 0x15
	jc e820_fail
        cmp eax, 0x534D4150
        jne e820_fail

        mov al, cl
	add al, '0'
        mov ah, 0x0E
        int 0x10

        mov al, ':'
        int 0x10


        mov al, [e820_buf + 16]
        add al, '0'
        mov ah, 0x0E
        int 0x10

	mov al, ' '
        int 0x10

        inc cx
        test ebx, ebx
        jnz do_e820
	
	jmp hang
e820_fail:
        mov si, failmsg
.fail_print: 
        lodsb
        or al, al
        jz hang
        mov ah, 0x0E
        int 0x10
        jmp .fail_print


hang:

	hlt
	jmp $

msg db "NOW IN SECOND   ",0

failmsg db "E820 FAIL",0
e820_buf:
        times 24 db 0
