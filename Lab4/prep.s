.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF
.text
.global _start
.org 0
_start:

	movia 	sp, 0x7FFFFC
loop:
	call	GetChar
	call	PrintChar
	br		loop
	
GetChar:
	subi 	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)

gc_loop:
	movia	r4, JTAG_UART_BASE #data
	ldwio	r2, 0(r4)
	andi	r3, r2, 0x8000
	beq		r3, r0, gc_loop
	
	andi	r2, r2, 0xFF
	
	ldw		r3, 4(sp)
	ldw		r4, 0(sp)
	addi 	sp, sp, 8
	
	ret
	
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
	
	.end
	