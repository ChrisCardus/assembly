    .data
    .align 2

itemcount:  .asciiz "\nEnter number of integers to be sorted>"
listitem:   .asciiz "\nEnter integers to be sorted>"
gap:        .asciiz ", "

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
    bgez    $t0, SUBROUTINES

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
SUBROUTINES:
    # Initialise $s3, $s4, $s5
    jal     RETURN
    # Bubble Sort Subroutine
    jal     BUBBLE
    
# Print the sorted list
PRINT:
    # Prepare to print some integers
    li      $v0, 1
    lw      $a0, ($s4)
    syscall
    # Check if we've reached the end of the heap
    addi    $s4, $s4, 4
    sub     $t6, $s4, $s3
    # If so, exit program
    bgez    $t6, EXIT
    # Else print a gap
    li      $v0, 4
    la      $a0, gap
    syscall
    j       PRINT

# End the program
EXIT:
    li $v0, 10
    syscall
    
# Start of bubble sort
BUBBLE:
    # Check if $s3 has been reduced to zero
    sub     $t0, $s0, $s3
    bgez    $t0, RETURN

    # Load the integers at locations $s4 & $s5 from the heap
    lw      $s6, ($s4)
    lw      $s7, ($s5)

    # Compare two elements
    sub     $t0, $s7, $s6
    bgez    $t0, NOCHANGE

    # Switch $s6 & $s7 on the heap
    sw      $s6, ($s5)
    sw      $s7, ($s4)

    NOCHANGE:
    # Increment both $s4 & $s5 to the memory address of the next to items to be compared
    addi    $s4, $s4, 4
    addi    $s5, $s5, 4

    # Check if $s5 is the end of the heap
    sub     $t5, $s5, $s3
    bgez    $t5, LOCKLAST

    j BUBBLE
    
# Lock the position of the last digit; this digit is sorted
LOCKLAST:
    # Reduce the maximum size $s3 by 1 word
    li      $t3, 4
    sub     $s3, $s3, $t3
    addi	$s4, $s0, 0
    addi    $s5, $s0, 4
    j BUBBLE
        
# Return to the location in $ra
RETURN:
    # Store maximum memory address
    li      $t3, 4
    mul     $t4, $s1, $t3
    add     $s3, $t4, $s0
    
    # Store addresses of first two items in heap
    addi	$s4, $s0, 0
    addi    $s5, $s0, 4
    
    # Jump to location $ra
    jr      $ra