.data
prompt1: .asciiz "Enter the size of the array (N): "
prompt2: .asciiz "Enter N integers (1 word each): "
prompt3: .asciiz "This is the new array: "
array: .space 100

.text
.globl main

main:
    # Prompt user for size of the array
    li $v0, 4
    la $a0, prompt1
    syscall

    # Read the size of the array
    li $v0, 5
    syscall
    move $t0, $v0 # Store the size of the array in $t0

    # Prompt user for N integers
    li $v0, 4
    la $a0, prompt2
    syscall

    # Read N integers and store them in the array
    la $t1, array
    li $t2, 0 # Counter
    loop:
        beq $t2, $t0, end_loop
        li $v0, 5
        syscall
        sw $v0, 0($t1)
        addi $t1, $t1, 4
        addi $t2, $t2, 1
        j loop
    end_loop:


    # Display the inverted array
    li $v0, 4
    la $a0, prompt3
    syscall
    li $v0, 1
    la $t1, array
    loop2:
        lw $a0, 0($t1)
        syscall
        addi $t1, $t1, 4
        addi $t2, $t2, 1
        bne $t2, $t0, loop2

    # Exit program
    li $v0, 10
    syscall

