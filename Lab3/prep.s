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
	
	movia 	r2, TEXT
	call	PrintString
	
	break	
	
PrintChar:
	subi	sp, sp, 12
	stw		ra, 8(sp)
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	movia	r3, JTAG_UART_BASE
pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)
	andhi	r4, r4, WSPACE_MASK
	beq		r4, r0, pc_loop
	stwio	r2, DATA_OFFSET(r3)
	
	ldw		ra, 8(sp)
	ldw		r3, 4(sp)
	ldw		r4, 0(sp)
	addi	sp, sp, 12
	ret
	
PrintString:
	subi	sp, sp, 8
	stw		r2, 4(sp)
	stw		r3, 0(sp)
	
	mov		r3, r2
	
ps_loop:
	ldb		r2, 0(r3)
	beq		r2, r0, ps_loop_end
	call	PrintChar
	addi 	r3, r3, 1
	br		ps_loop
	
ps_loop_end:
	ldw		r2, 4(sp)
	ldw		r3, 0(sp)
	addi	sp, sp, 8
	
	ret
	
TEXT:		.ascii	"This text will be "
			.asciz	"printed.\n***\n"

.end