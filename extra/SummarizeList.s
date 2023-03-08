.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF
.text
.global _start
.org 0
_start:
	movia 	sp, 0x7FFFFC
	movi	r2, '\n'
	call 	PrintChar
	movi	r2, '2'
	call 	PrintChar
	movi	r2, '7'
	call 	PrintChar
	movi	r2, '4'
	call 	PrintChar
	movi	r2, '\n'
	call 	PrintChar
	
	movia	r2, LIST
	ldw		r3, N(r0)
	call	SummarizeList
	
	break
	
PrintChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	movia	r3, JTAG_UART_BASE
pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)
	andhi	r4, r4, WSPACE_MASK
	beq		r4, r0, pc_loop
	stwio	r2, DATA_OFFSET(r3)
	ldw		r3, 4(sp)
	ldw		r4, 0(sp)
	addi	sp, sp, 8
	ret

SummarizeList:
	subi	sp, sp, 24
	stw		r2,	20(sp)
	stw		r3, 16(sp)
	stw		r4, 12(sp)
	stw		r5, 8(sp)
	stw		r6, 4(sp)
	stw		ra, 0(sp)
	
	mov		r4, r2
	
sl_loop:
sl_if:
	ldw		r5, 0(r4)
	cmpne	r5, r5, r0
	bgt		r5, r0, sl_else
	
sl_then:
	movi	r2, '0'
	call 	PrintChar
	br		sl_end_if
	
sl_else:
	movi	r2, '*'
	call 	PrintChar
	
sl_end_if:
	addi	r4, r4, 4
	subi	r3, r3, 1
	bgt		r3, r0, sl_loop
	
sl_end_loop:
	movi	r2, '\n'
	call	PrintChar
	
	ldw		r2,	20(sp)
	ldw		r3, 16(sp)
	ldw		r4, 12(sp)
	ldw		r5, 8(sp)
	ldw		r6, 4(sp)
	ldw		ra, 0(sp)
	addi 	sp, sp, 24
	ret

LIST:	.word	1, 6, 0, 2, -300, 0, -9999, 44, 0, 3
N:		.word	10

.end