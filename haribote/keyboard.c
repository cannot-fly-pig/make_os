/* キーボード関係 */

#include "bootpack.h"

#define PORT_KEYDAT		0x0060

struct FIFO8 keyfifo;

void inthandler21(int *esp)
/* PS/2キーボードからの割り込み */
{
	unsigned char data;
	io_out8(PIC0_OCW2, 0x61);	/* IRQ-01受付完了をPICに通知 */
	data = io_in8(PORT_KEYDAT);
	fifo8_put(&keyfifo, data);
	return;
}

#define PORT_KEYDAT				0x0060
#define PORT_KEYSTA				0x0064
#define PORT_KEYCMD				0x0064
#define KEYSTA_SEND_NOTREADY	0x02
#define KEYCMD_WRITE_MODE		0x60
#define KBC_MODE				0x47

void wait_KBC_sebdready(void) {
	/* キーボードコントローラーがデータ送信可能になるのを待つ */
	for(;;){
		if ((io_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0){
			return;
		}
	}
}

void init_keyboard(void) {
	wait_KBC_sebdready();
	io_out8(PORT_KEYCMD, KEYCMD_WRITE_MODE);
	wait_KBC_sebdready();
	io_out8(PORT_KEYDAT, KBC_MODE);
	return;
}
