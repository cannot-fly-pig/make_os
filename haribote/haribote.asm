	org     0xc200      ; 0xc200 <- 0x8000 + 0x4200
													; where on memory this program will be loaded

	mov     al, 0x13    ; vga graphics, 320x200x8bit
	mov     ah, 0x00
	int     0x10

fin:
	hlt
	jmp     fin
