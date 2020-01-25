default:
	make img

ipl10.bin : ipl10.nas Makefile
	nasm ipl10.nas -o ipl10.bin -l ipl10.lst

asmhead.bin : asmhead.nas Makefile
	nasm asmhead.nas -o asmhead.bin -l asmhead.lst

nasmfunc.o : naskfunc.nas Makefile
	nasm -g -f elf naskfunc.nas -o nasmfunc.o

bootpack.hrb : bootpack.c har.ld nasmfunc.o Makefile       # Cファイルをリンカスクリプトを用いてコンパイル
	gcc -fno-pic -march=i486 -m32 -nostdlib -T har.ld -g bootpack.c nasmfunc.o -o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
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
	rm *.lst *.bin *.sys *.img *.hrb
