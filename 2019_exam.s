.equ	JTAG_UART_BASE, 0x10001000
.equ	DATA_OFFSET, 	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF

.text
.global _start
.org	0

_start:
	movia	sp, 0x7FFFFC
	
	movia	r2, TEXT
	call	PrintString
	movia	r2, BUFFER
	call	GetString
	movi	r4, 'A'
	movi	r5, 'Z'
	mov		r6, r0
count_loop:
	ldb		r3, 0(r2)
	beq		r3, r0, count_loop_end
if:
	blt		r3, r4, end_if
	bgt		r3, r5, end_if
then:
	addi	r6, r6, 1
end_if:
	addi	r2, r2, 1
	br		count_loop
	
count_loop_end:
	stw		r6, COUNT(r0)
	
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

GetChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)

gc_loop:
	movia	r4, JTAG_UART_BASE
	ldwio	r2, 0(r4)
	andi	r3, r2, 0x8000
	beq		r3, r0, gc_loop
	andi	r2, r2, 0xFF
	
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
	call 	PrintChar
	addi	r3, r3, 1
	br		ps_loop
ps_loop_end:
	
	ldw		ra, 8(sp)
	ldw		r2, 4(sp)
	ldw		r3, 0(sp)
	addi	sp, sp, 12
	
	ret
	
GetString:
	subi	sp, sp, 16
	stw		ra, 12(sp)
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		r4, 0(sp)

	mov		r3, r2
	movi	r4, '\n'

gs_loop:
	call 	GetChar
	beq		r2, r4, gs_loop_end
	call	PrintChar
	stb		r2, 0(r3)
	addi	r3, r3, 1
	br		gs_loop
	
gs_loop_end:
	movi	r4, 0x00
	stb		r4, 0(r3)
	
	ldw		ra, 12(sp)
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		r4, 0(sp)
	addi	sp, sp, 16
	
	ret

.org 	0x1000

COUNT:	.skip	4
TEXT:	.asciz	"Type 80 chars. or less and press Enter"

.org	0x2000

BUFFER:	.skip	81


	.end