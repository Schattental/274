.text
.global _start
.org 0
_start:
	movia	sp, 0x7FFFFC
	movia	r2, LIST
	ldw		r3, N(r0)
	call 	MakeNonNegative
	movi	r8, 5
	stw		r8, 0x2E08(r0)
	break
	
MakeNonNegative:
	subi	sp, sp, 16
	stw		r2,	12(sp)
	stw		r3, 8(sp)
	stw		r4, 4(sp)
	stw		ra, 0(sp)
	
	mov 	r4, r2
	
mnn_loop:
	ldw 	r2, 0(r4)
	call 	AbsoluteValue
	stw		r2, 0(r4)
	addi 	r4, r4, 4
	subi	r3, r3, 1
	bgt		r3, r0, mnn_loop
	
	ldw		r2,	12(sp)
	ldw		r3, 8(sp)
	ldw		r4, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 16
	
	ret
	
AbsoluteValue:
	subi	sp, sp, 4
	stw		r3,	0(sp)
av_if:
	bge 	r2, r0, av_else
av_then:
	srai	r3, r2, 31
	xor		r2, r2, r3
	sub		r2, r2, r3
	#sub 	r2, r0, r2
	br		av_end_if
av_else:
	mov 	r2, r2 # not really needed
av_end_if:
	
	ldw		r3, 0(sp)
	addi	sp, sp, 4
	ret
	
	
.org 0x1000
LIST: 	.word	-15, 0, 3, 15, -3
N:		.word	5

	.end
	
	