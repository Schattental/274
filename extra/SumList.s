.text
.global _start
.org	0
_start:
	movia	sp, 0x7FFFFC
	movia 	r2, LIST 	# pointer
	ldw 	r3, N(r0) 	# count
	call 	SumList
	stw 	r2, SUM(r0)
	
	break
	
SumList:
	subi	sp, sp, 12
	stw		r3, 8(sp)
	stw		r4, 4(sp)
	stw		r5, 0(sp)
	
	movi	r4, 0
	
loop:
	ldw		r5, 0(r2)
	stw		r0, 0(r2)
	add 	r4, r4, r5
	addi	r2, r2, 4
	subi	r3, r3, 1
	bgt		r3, r0, loop

loop_end:
	mov		r2, r4
	ldw		r5, 0(sp)
	ldw		r4, 4(sp)
	ldw		r3, 8(sp)
	addi	sp, sp, 12
	ret

.org	0x1000
N:		.word 	5
LIST:	.word	1, 2, 3, 8, 4
SUM:	.skip	4
	
.end