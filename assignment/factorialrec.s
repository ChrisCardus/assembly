### Recursive factorial in MIPS

### Standard header information	
	.data
	.align 2

### Define strings	
input:  	.asciiz "\nEnter a number>"
cr:	 	.asciiz "\n"
errmsg:	.asciiz "\nError - must enter a positive integer\n"
	
### Standard preliminaries
        .text
        .globl main
main:
	
# Prompt for first input	
INPUT:
	li 	$v0,4		; # System call code 4 for print string
        la 	$a0,input	; # Argument string as input
        syscall			; # Print the string
# Read first input 
        li 	$v0,5		; # System call code 5 to read int input
        syscall			; # Read it
	move 	$a0,$v0	; # move number into a0
	bgtz	$a0,JFACT	; # If valid input goto main code, else get input again
        li 	$v0,4		; # System call code 4 for print string
        la 	$a0,errmsg	; # Argument string as input
        syscall			; # Print the string
	j INPUT			; # get the input again
	
JFACT:
	jal 	FACT	       	; # jump to factorial function
	move 	$a0,$v0      	; # copy result into a0 for printing
	li 	$v0, 1		; # Set up for printing
	syscall			; # Call the print routine
	li	$v0,4		; # Setup for string printing
	la	$a0,cr		; # Load address of string for printing
	syscall			; # Print the string

EXIT:
	li 	$v0,10		; # System call code for exit
        syscall			; # exit
	
FACT:
	subi $t0,$a0,1
	bgez 	$t0,REC	; # if N>1 recurse
	li	$v0,1		; # else return 1
	j	RET		; # jump to the return

REC:
	addi	$sp,$sp,-8	; # decrement sp
	sw	$a0,4($sp)	; # push a0 onto stack
	sw	$ra,0($sp)	; # push ra onto stack
	addi	$a0,$a0,-1	; # N-1 into a0
	jal 	FACT		; # jump to fact
	lw	$a0,4($sp)	; # pop stack into a0
	lw	$ra,0($sp)	; # pop stack into ra
	addi	$sp,$sp,8	; # increment sp
	mul	$v0,$v0,$a0	; # return val is N*fact(N-1)

RET:
	jr	$ra		; # return


