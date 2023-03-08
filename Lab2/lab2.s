#-------------------------------------
# Lab 2 - Feb 1, 2023
# Faller, Gregor, Lossius
#
# Thank you / Merci / Danke!
#-------------------------------------

	.equ	JTAG_UART_BASE,	0x10001000
	.equ	DATA_OFFSET,	0
	.equ	STATUS_OFFSET,	4
	.equ	WSPACE_MASK,	0xFFFF
	
	.text
	.global _start
	.org 	0x0000
	
_start:
	movia 	sp, 0x7FFFFC
	movia	r2, LIST1 # listCalc = ListCalculation(s, t, n, value)
	movia	r3, LIST2 
	movia	r4, N 
	ldw		r4, 0(r4)
	movi	r5, 15
	call ListCalculation
	movia 	r3, RESULT
	stw		r2, 0(r3)
_end:
	br	_end

#-----------------------------------------------------------------------

ListCalculation: #r2, r3, r4, r5 for input params
	subi	sp, sp, 20
	stw 	r3, 16(sp)	# list 2 pointer
	stw		r4, 12(sp)  # orig n
	stw		r6, 8(sp)  	# count
	stw		r7, 4(sp) 	# list 1 element
	stw 	r8, 0(sp) 	# list 2 element
	
	movi	r6, 0      	# count = 0

lc_loop:
lc_if:
	ldw 	r7,	0(r2)
	ldw 	r8, 0(r3)
	muli	r9, r8, 2 	# double t[i] 
	blt		r7, r9, lc_else	
	
lc_then:
	addi	r6, r6, 1
	br 		lc_end_if
	
lc_else:
	stw		r5, 0(r2)
	stw 	r0, 0(r3)
	
lc_end_if:
	subi	r4, r4, 1 	# decrement n
	addi 	r2, r2, 4	# point to next element of LIST1
	addi	r3, r3, 4	# point to next element of LIST2
	
	bgt		r4, r0, lc_loop # check loop status
	
	mov 	r2, r6	# store count for return
	
	ldw		r3, 16(sp)
	ldw		r4, 12(sp)  
	ldw		r6, 8(sp)  	
	ldw		r7, 4(sp) 	
	ldw 	r8, 0(sp) 	
	addi	sp, sp, 20
	
	ret 
#-----------------------------------------------------------------------
	
		.org 	0x1000
RESULT:	.skip	4
N:		.word	3
LIST1:	.word 	5, 6, 7
LIST2:	.word	3, 2, 1

	.end