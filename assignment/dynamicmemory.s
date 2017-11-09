	.data
	.align 2

input:  .asciiz "\nEnter array size>"
input2:	.asciiz "\nEnter a number>"
cr: 	.asciiz "\n"
	
        .text
        .globl main

main:
        li 	$v0,4		; # System call code 4 for print string
        la 	$a0,input	; # Argument string as input
        syscall			; # Print the string
        li 	$v0,5		; # System call code 5 to read int input
        syscall			; # Read it
	move	$s1,$v0	; # Put N in s1
	li $t0,4
	mul $a0,$s1,$t0	; # amount of space is 4N bytes or N words
	li 	$v0,9		; # syscall code 9 is sbrk allocate heap
	syscall			;
	move 	$s0,$v0	; # Copy base address of heap region to s0
	li 	$s2,0		; # i=0 in s2
LOOP:	sub	$t0,$s2,$s1	; # i-N in t0
	bgez	$t0,ELOOP	; # exit loop
        li 	$v0,4		; # System call code 4 for print string
        la 	$a0,input2	; # Argument string as input
        syscall			; # Print the string
        li 	$v0,5		; # System call code 5 to read int input
        syscall			; # Read it
	li	$t1,4		; # const 4 in t1
	mul	$t1,$s2,$t1	; # compute array offset in t1
	add	$t2,$s0,$t1	; # add to base address
	sw	$v0,($t2)	; # store data
	addi	$s2,$s2,1	; # i++
	j 	LOOP		; # loop
ELOOP:	nop			;

### Print the array contents
	li 	$s2,0		; # i=0 in s2
LOOP2:	sub	$t0,$s2,$s1	; # i-4 in t0
	bgez	$t0,ELOOP2	; # exit loop
	li	$t1,4		; # const 4 in t1
	mul	$t1,$s2,$t1	; # compute array offset in t1
	add	$t2,$s0,$t1	; # add to base address
	lw	$a0,($t2)	; # load data into a0 for printing
        li 	$v0,1		; # System call code 5 to print int
        syscall			; # Read it
	li	$v0,4		; # System call code 4 for print string
	la	$a0,cr		; # Argument string as input
	syscall			; # Print the string
	addi	$s2,$s2,1	; # i++
	j 	LOOP2		; # loop
ELOOP2:	nop			;

### Make a clean exit from the program. Also deallocates the heap
        li 	$v0,10;			# System call code for exit
        syscall                         # exit
