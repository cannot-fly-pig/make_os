helloos.img: ipl.bin Makefile
	../z_tools/edimg.exe imgin:../z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 imgout:helloos.img

ipl.bin: ipl.asm Makefile
	nasm ipl.asm -o ipl.bin

img:
	make -r helloos.img

asm:
	make -r ipl.bin

run: helloos.img
	qemu-system-i386 ./helloos.img

clean:
	rm ipl.bin


