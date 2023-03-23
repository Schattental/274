.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF
.text
.global _start
.org 0

_start:
	movia 	sp, 0x7FFFFC
	
	movia	r6, LIST
	ldw		r3, N(r0) 
	movi	r5, 'V'
	movia	r7, 0xFFFFFFFF
	movia	r8, 0x01010101
	
	movia 	r2, TEXT
	call	PrintString
	
main_loop:
	call 	GetChar
	call 	PrintChar
	mov		r4, r2
	movi	r2, ' '
	call	PrintChar
	mov		r2, r4
	call 	PrintHexByte
	movi	r2, '\n'
	call 	PrintChar
main_if:
	bne 	r4, r5, main_else
	stw		r7, 0(r6)
	br 		main_end_if
main_else:
	stw		r8, 0(r6)
main_end_if:
	addi 	r6, r6, 4
	subi	r3, r3, 1
	bgt		r3, r0, main_loop

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
	
phd_if:
	movi 	r3, 10
	bge		r2, r3, phd_else
	
phd_then:
	addi 	r2, r2, '0'
	br 		phd_end_if
	
phd_else:
	subi 	r2, r2, 10
	addi 	r2, r2, 'A'
	
phd_end_if:
	call 	PrintChar
	
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi 	sp, sp, 12
	
	ret
	
PrintHexByte:
	subi 	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov 	r3, r2
	
	srli	r2, r3, 4
	call 	PrintHexDigit
	andi 	r2, r3, 0xF
	call 	PrintHexDigit
	
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi 	sp, sp, 12
	
	ret
	
DisplayByteList:
	subi	sp, sp, 16
	stw		r2, 12(sp)
	stw		r3, 8(sp)
	stw		r4, 4(sp)
	stw		ra, 0(sp)
	
	mov		r4, r2
	
dbl_loop:
	movi	r2, '('
	call	PrintChar
	ldbu	r2, 0(r4)
	call	PrintHexByte
	movi	r2, ')'
	call	PrintChar
	movi	r2, ' '
	call	PrintChar
	
	subi	r3, r3, 1
	addi	r4, r4, 1
	
	bgt		r3, r0, dbl_loop
	
	movi	r2, '\n'
	call	PrintChar

	ldw		r2, 12(sp)
	ldw		r3, 8(sp)
	ldw		r4, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 16
	
	ret
	
IncreaseByteList:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		r5, 0(sp)
	
ibl_loop:
	ldbu	r5, 0(r2)
	add		r5, r5, r4
	stb		r5, 0(r2)
	
	subi	r3, r3, 1
	addi	r2, r2, 1
	
	bgt		r3, r0, ibl_loop
	
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		r5, 0(sp)
	addi	sp, sp, 12
	
	ret
	
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
	
	.org 0x1000
	
LIST:	.skip 	4

N:		.word 	4

TEXT:	.ascii	"Lab 4"
		.asciz	"\n"
		
	.end
