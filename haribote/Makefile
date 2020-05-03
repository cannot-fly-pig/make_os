default:
	make run && make clean

%.bin : %*.asm 
	nasm $*.asm -o $*.bin -l $*.lst

nasmfunc.obj : nasmfunc.asm 
	nasm -g -f elf nasmfunc.asm -o nasmfunc.obj

convHankakuTxt.bin : convHankakuTxt.c 
	gcc convHankakuTxt.c -o convHankakuTxt.bin

hankaku.c : hankaku.txt convHankakuTxt.bin 
	./convHankakuTxt.bin

bootpack.hrb : bootpack.c har.ld nasmfunc.obj hankaku.c mysprintf.c dsctbl.c graphic.c fifo.c
	gcc -fno-pic -march=i486 -m32 -nostdlib -T har.ld -g nasmfunc.obj \
		fifo.c \
		bootpack.c \
		dsctbl.c \
		graphic.c \
		hankaku.c \
		mysprintf.c \
		int.c \
		-o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb 
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys 
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

asm :
	make -r ipl10.bin

img :
	make -r haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img  # "-fda" for floppy disk

debug :
	make img
	qemu-system-i386 -fda haribote.img -gdb tcp::10000 -S

clean :
	rm *.lst *.bin *.sys *.img *.hrb *.obj
