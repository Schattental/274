.text
.global _start
.org 0
_start:
	movia	sp, 0x7FFFFC
	movia	r2, L
	ldw 	r3, N(r0)
	call 	MaximumValue
	stw		r2,	RESULT(r0)
	break

MaximumValue:
	subi	sp, sp, 12
	stw		r3, 8(sp)
	stw		r4, 4(sp)
	stw		r5, 0(sp)
	
	movia 	r4, 0x80000000 # init most negative number
mv_loop:
mv_if:
	ldw 	r5, 0(r2)
	ble 	r5, r4, mv_end_if
mv_then:
	mov		r4, r5
mv_end_if:
	addi	r2, r2, 4
	subi	r3, r3, 1
	bgt		r3, r0, mv_loop
	mov		r2, r4
	
	ldw		r5, 0(sp)
	ldw		r4, 4(sp)
	ldw		r3, 8(sp)
	addi	sp, sp, 12
	ret



.org 0x1000
N:		.word	5
L:		.word	1, -99, 4, 69, 420
RESULT: .skip	4

	.end