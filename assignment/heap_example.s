	.data
	.align 2

input:	.asciiz "\nEnter array size>"
input2:	.asciiz "\nEnter an integer>"
cr:	.asciiz "\n"

	.text
	.globl main

main:
	li $v0, 4	# System call code 4 to print string
	la $a0, input	# Argument string
	syscall 	# Print the string in $a0

	li $v0, 5	# System call code 5 to read int
	syscall		# Read the int
	move $s1, $v0	# Put N in s1
	
	li $t0, 4	# Const 4 in t0
	mul $a0, $s1, $t0	# 4N bytes
	li $v0, 9	# System call code 9 allocate on heap
	syscall
	move $s0, $v0	# Copy base address of heap region
	li $s2, 0	# Counter i=0

LOOP:
	sub $t0, $s2, $s1	# $t0=i-N
	bgez $t0, ELOOP		# Exit loop if t0>=0
	
	li $v0, 4	# System call code 4 to print string
	la $a0, input2	# Argument string
	syscall		# Print string

	li $v0, 5	# System call code 5 to read int
	syscall		# Read the int

	li $t1, 4		# Const 4 in t1
	mul $t1, $s2, $t1	# Compute array offset
	add $t2, $s0, $t1	# Add to base address
	sw $v0, ($t2)		# Store data
	addi $s2, $s2, 1	# Counter i++
	j LOOP		# Loops

ELOOP:
	nop		# No operation

### Print array
	li $s2, 0	# Counter i=0
LOOP2:
	sub $t0, $s2, $s1	# t0=i-N
	bgez $t0, ELOOP2	# Exit loop if t0>=0

	li $t1, 4		# Const 4
	mul $t1, $s2, $t1	# Compute array offset
	add $t2, $s0, $t1	# Add to base address
	lw $a0, ($t2)		# Load data into a0 to print
	li $v0, 1	# System Call code 5 to print int
	syscall		# Print int
	li $v0, 4	# System Call code 4 to print string
	la $a0, cr	# Argument string
	syscall		# Print string
	addi $s2, $s2, 1	# Counter i++
	j LOOP2		# Loops

ELOOP2:
	nop		# No operation

### Make a clean exit to the code
	li $v0, 10	# System call code 10 to success
	syscall		# Exit program



