section .text
	global io_hlt, io_cli, io_sti, io_stihlt
	global io_in8, io_in16, io_in32
	global io_out8, io_out16, io_out32
	global io_load_eflags, io_store_eflags
	global load_gdtr, load_idtr
	extern inthandler21, inthandler27, inthandler2c
	global asm_inthandler21, asm_inthandler27, asm_inthandler2c


io_hlt:	; void io_hlt(void);
 	hlt
 	ret

io_cli:	; void io_cli(void);
 	cli
 	ret

io_sti:	; void io_sti(void);
 	sti
 	ret

io_stihlt:	; void io_stihlt(void);
 	sti
 	hlt
 	ret

io_in8:	; int io_in8(int port);
 	mov		edx,[esp+4]		; port
 	mov		eax,0
 	in		al,dx
 	ret

io_in16:	; int io_in16(int port);
 	mov		edx,[esp+4]		; port
 	mov		eax,0
 	in		ax,dx
 	ret

io_in32:	; int io_in32(int port);
 	mov		edx,[esp+4]		; port
 	in		eax,dx
 	ret

io_out8:	; void io_out8(int port, int data);
 	mov		edx,[esp+4]		; port
 	mov		al,[esp+8]		; data
 	out		dx,al
 	ret

io_out16:	; void io_out16(int port, int data);
 	mov		edx,[esp+4]		; port
 	mov		eax,[esp+8]		; data
 	out		dx,ax
 	ret

io_out32:	; void io_out32(int port, int data);
 	mov		edx,[esp+4]		; port
 	mov		eax,[esp+8]		; data
 	out		dx,eax
 	ret

io_load_eflags:	; int io_load_eflags(void);
 	pushfd		; push eflags という意味
 	pop		eax
 	ret

io_store_eflags:	; void io_store_eflags(int eflags);
		mov		eax,[esp+4]
		push	eax
		popfd		; pop eflags という意味
		ret

load_gdtr:		; void load_gdtr(int limit, int addr);
		mov		ax,[esp+4]		; limit
		mov		[esp+6],ax
		lgdt	[esp+6]
		ret

load_idtr:		; void load_idtr(int limit, int addr);
		mov		ax,[esp+4]		; limit
		mov		[esp+6],ax
		lidt	[esp+6]
		ret

asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		push	es
		push	ds
		pushad
		mov		eax,esp
		push	eax
		mov		ax,ss
		mov		ds,ax
		mov		es,ax
		call	inthandler2c
		pop		eax
		popad
		pop		ds
		pop		es
		iretd
