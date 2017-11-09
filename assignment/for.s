	.data
	.align 2

varx:	.word 6
vary:	.word 0

	.text
	.globl main

main:
	lw $t1,varx                       ;# t1<-x      
	li $t2,0                         ;# t2<-(y=0)
	li $t3,1                          ;# t3<-(i=1)
L1:	sub $t4,$t3,$t1    ;# t4<-i-x
	bgtz $t4,L2                ;# i-x>0 goto L2
	add $t2,$t2,$t3         ;# y=y+i
	addi $t3,$t3,1            ;# i++
	j L1                               ;# loop
L2: 	sw $t2,vary             ;# store y
	li 	$2,10
	syscall
