.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF
.text
.global _start
.org 	0
_start:
	movia	sp, 0x7FFFFC
	movia	r6, LIST
	movia	r2, TEXT
	call 	PrintString
	movi	r3, 0x0
	ldw		r4, N(r0)
	movi	r5, 0

main_loop:
	beq		r4, r0, main_loop_end
	mov		r2, r3
	call 	PrintHexDigit
	movi	r2, ':'
	call 	PrintChar
	ldw		r2, 0(r6)
	bge		r2, r0, else
	movi	r2, 'N'
	call 	PrintChar
	addi	r5, r5, 1
	br		main_end_if
else:
	movi	r2, '.'
	call 	PrintChar
main_end_if:
	movi	r2, '\n'
	call 	PrintChar
	subi 	r4, r4, 1
	addi	r3, r3, 1
	addi	r6, r6, 4
	br		main_loop
	
main_loop_end:
	stw		r5, NEG_COUNT(r0)
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
	
PrintString:
	subi	sp, sp, 12
	stw		ra, 8(sp)
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
	ldw 	ra, 8(sp)
	ldw		r2, 4(sp)
	ldw		r3, 0(sp)
	addi	sp, sp, 12
	
	ret
	
PrintHexDigit:
	subi 	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	movi 	r3, 10
	bge		r2, r3, phd_else
	addi 	r2, r2, '0'
	call 	PrintChar
	br		phd_end_if
phd_else:
	subi 	r2, r2, 10
	addi 	r2, r2, 'A'
	call 	PrintChar
phd_end_if:
	
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi 	sp, sp, 12
	
	ret
	
.org	0x1000
NEG_COUNT:	.skip	4
N:	.word	5
LIST:	.word	0xAA, -33, 0, -11, 0xFFFFFFFF
TEXT:	.asciz	"Summary of element values\n"

.end
