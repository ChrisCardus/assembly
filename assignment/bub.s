    .data
    .align 2

itemcount:  .asciiz "\nEnter number of integers to be sorted>"
listitem:       .asciiz "\nEnter integers to be sorted>"
cr:         .asciiz "\n"

    .text
    .globl main

main:
    # Store itemcount in $s1
    li      $v0, 4
    la      $a0, itemcount
    syscall
    li      $v0, 5
    syscall
    move    $s1, $v0

    # Allocates 4*s1 space on the heap and stores the base address in $s0
    li      $t3, 4
    mul     $a0, $s1, $t3
    li      $v0, 9
    syscall
    move    $s0, $v0

    # Counter set to 0
    li      $s2, 0

# Start of the READ loop
READ:
    #Check that $s2 is less than itemcount
    sub     $t0, $s2, $s1
    bgez    $t0, EREAD

    # Read items ready to be sorted in the heap
    li      $v0, 4
    la      $a0, listitem
    syscall
    li      $v0, 5
    syscall

    # Calculate offset from the base address
    li      $t1, 4
    mul     $t1, $s2, $t1
    add     $t2, $s0, $t1

    # Store number in the heap
    sw      $v0, ($t2)

    # Increment counter
    addi    $s2, $s2, 1

    # Jump to start of READ
    j       READ

# End of the READ loop
EREAD:

    # Reset counter
    li      $s2, 0
    
    # Store maximum memory address
    li      $t3, 4
    mul     $t4, $s1, $t3
    add     $s3, $t4, $s0

    # Initialise two addresses to be compared
    addi	$s4, $s0, 0
    addi    $s5, $s0, 4
    
    
# Start of bubble sort
BUBBLE:
    # Check if $s3 has been reduced to zero
    sub     $t0, $s0, $s3
    bgez    $t0, EBUBBLE

    # Compare two elements
    sub     $t0, $s5, $s4
    bgez    $t0, NOCHANGE

    # Switch $s4 & $s5
    addi    $t5, $s4, 0
    move    $s4, $s5
    move    $s5, $t5

    NOCHANGE:
    # Increment both $s4 & $s5 to the memory address of the next to items to be compared
    addi    $s4, $s4, 4
    addi    $s5, $s5, 4

# End of bubble sort
EBUBBLE:

    li $v0, 10
    syscall