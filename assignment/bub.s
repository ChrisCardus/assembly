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
    multi   $a0, $s1, 4
    li      $v0, 9
    syscall
    move    $s0, $v0

    # Counter set to 0
    li      $s2, 0

# Start of the READ loop
READ:
    #Check that $s2 is less than itemcount
    sub     t0, $s2, $s1
    bgez    t0, EREAD

    # Read items ready to be sorted in the heap
    li      $v0, 4
    la      $a1, listitem
    syscall
    li      $v0, 5
    syscall

    # Calculate offset from the base address
    li      $t1, 4
    mult    $t1, $s2, $t1
    add     $t2, $s0, $t1

    # Store number in the heap
    sw      $v0, ($t2)

    # Increment counter
    addi    $s2, $s2, 1

    # Jump to start of READ
    j READ

# End of the READ loop
EREAD:
    