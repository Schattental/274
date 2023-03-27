.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF
.text
.global _start
.org 0
_start:
	movia 	sp, 0x7FFFFC
	movia	r2, TEXT
	call	PrintString
	call 	MakeUppercase
	movia	r2, TEXT
	call 	PrintString
	
	break
	
MakeUppercase:
	subi 	sp, sp, 12
	stw		r3, 8(sp)
	stw		r4,	4(sp)
	stw		r5, 0(sp)
	
	movi 	r3, 0
	
mu_loop:
mu_if:
	ldb 	r4, 0(r2)
	beq		r4, r0, mu_end_loop
	
mu_end_if:
mu_if2:
	movi	r5, 'a'
	blt 	r4, r5, mu_end_if2
	movi	r5, 'z'
	bgt		r4, r5, mu_end_if2
	
	movi	r5, 'a'
	subi	r5, r5, 'A'
	sub		r4, r4, r5
	stb		r4, 0(r2)
	
	addi	r3, r3, 1
	
mu_end_if2:
	addi	r2, r2, 1
	br		mu_loop
	
mu_end_loop:
	mov		r2, r3
	
	ldw		r3, 8(sp)
	ldw		r4, 4(sp)
	ldw		r5, 0(sp)
	addi	sp, sp, 12
	
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
	
.org	0x1000
	
TEXT:	.asciz	"Hello Commander 221 we've been waiting\n"
	
	
.end