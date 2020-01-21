CYLS equ 10

	org 0x7c00

	jmp entry
	db 0x90
	db "HELLOIPL"
	dw 512
	db 1
	dw 1
	db 2
	dw 224
	dw 2880
	db 0xf0
	dw 9
	dw 18
	dw 2
	dd 0
	dd 2880
	db 0,0,0x29
	dd 0xffffffff
	db "HELLO-OS   "
	db "FAT12   "
	resb 18

; ほんへ
entry: ; レジスタ初期化
	mov ax, 0
	mov ss, ax
	mov sp, 0x7c00
	mov ds, ax
	mov es, ax

; ディスクを読む
	
	mov ax, 0x0820
	mov es, ax
	mov ch, 0 ; シリンダ0
	mov dh, 0 ; ヘッド0
	mov cl, 2 ; セクタ2

readloop:
	mov si, 0 ; カウンタ
retry:
	mov ah, 0x02 ; ディスク読み込み
	mov al, 1 ; 1セクタだけ
	mov bx, 0
	mov dl, 0x00 ; Aドライブ
	int 0x13 ; ディスクbios
	jnc fin
	add si, 1
	cmp si, 5
	jae error
	mov ah, 0x00
	mov dl, 0x00 ; Aドライブ
	int 0x13 ; ディスクbios
	jmp retry
next:
	mov ax, es
	add ax, 0x20
	mov es, ax
	add cl, 1
	cmp cl, 18
	jbe readloop ; if(cl <= 18) goto readloop;
	mov cl, 1
	add dh, 1
	cmp dh, 2
	jb readloop
	mov dh, 0
	add ch, 1
	cmp ch, CYLS
	jb readloop

	

fin:
	hlt
	jmp fin

error:
	mov si, msg

putloop:
	mov al, [si]
	add si, 1
	cmp al, 0
	je fin
	mov ah, 0x0e
	mov bx, 15
	int 0x10
	jmp putloop

msg:
	db 0x0a, 0x0a
	db "load error"
	db 0x0a
	db 0

	resb	0x1fe-($-$$)		; 0x7dfeまでを0x00で埋める命令
	db		0x55, 0xaa

jmp 0xc200
