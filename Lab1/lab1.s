.global _start
.org 0x0000

_start:
		ldw		r2, B(r0)
		addi	r2, r2, 3
		stw		r2, K(r0)
		ldw		r3, C(r0)
		mul		r3, r2, r3
		stw		r3, A(r0)
		ldw		r4, F(r0)
		add		r4, r3, r4
		stw		r4, W(r0)	
_end:
		br		_end
		
		.org	0x1000
B:		.word	1
C:		.word	2
F:		.word	3
K:		.skip	4
A:		.skip	4
W:		.skip	4

		.end
	