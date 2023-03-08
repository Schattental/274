.text
.global _start
.org	0
_start:
	movia 	sp, 0x7FFFFC
	movia	r2, LIST
	ldw		r3, N(r0)
	ldw		r4, K(r0)
	
	call	Scale
	call 	Scale
	break
	
Scale:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		r5, 0(sp)
	
	movi	r5, 0
	
s_loop:
	ldw		r5, 0(r2)
	mul		r5, r5, r4
	stw		r5, 0(r2)
	addi	r2, r2, 4
	subi	r3, r3, 1
	bgt		r3, r0, s_loop
	
s_loop_end:
	
	ldw		r5, 0(sp)
	ldw		r3, 4(sp)
	ldw		r2, 8(sp)
	addi 	sp, sp, 12
	
	ret


.org	0x1000

N:		.word	5
LIST:	.word	2, 4, 6, 8, 10
K:		.word	3

.end	