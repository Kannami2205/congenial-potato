.data
prompt1: .asciiz "Enter the size of the array (N): "
prompt2: .asciiz "Enter N integers representing the elements of the array: "

.text
# Procedure to perform in-place inversion of array and calculate average
performTask:
    # Prompt user for size of array
    li $v0, 4
    la $a0, prompt1
    syscall
    
    # Get the size of the array from the user
    li $v0, 5
    syscall
    move $t0, $v0
    
    # Prompt user for the elements of the array
    li $v0, 4
    la $a0, prompt2
    syscall
    
    # Allocate space for the array and store its elements
    li $t1, 4
    mul $t0, $t0, $t1
    la $a0, 0x10010400
    li $v0, 9
    move $a1, $t0
    syscall
    
    # In-place inversion of the array
    la $t2, 0x10010400  # t2 stores the base address of the array
    la $t3, 0x10010400  # t3 stores the address of the last element in the array
    add $t3, $t3, $t0  # add the size of the array to get the address of the last element
    subi $t3, $t3, 4   # subtract 4 to get the address of the last word in the array
    li $t4, 0          # t4 stores the first element of the array
loop:
    beq $t2, $t3, calcAverage
    lw $t5, ($t2)
    lw $t6, ($t3)
    sw $t6, ($t2)
    sw $t5, ($t3)
    addi $t2, $t2, 4
    subi $t3, $t3, 4
    j loop
    
# Calculate the integer average of all elements in the array
calcAverage:
    la $t2, 0x10010400  # t2 stores the base address of the array
    li $t3, 0          # t3 stores the sum of all elements in the array
    li $t4, 0          # t4 stores the number of elements in the array
calcSum:
    lw $t5, ($t2)
    add $t3, $t3, $t5
    addi $t2, $t2, 4
    addi $t4, $t4, 1
    bne $t4, $t0, calcSum
    
    # Calculate the integer average of all elements in the array
    div $t3, $t0
    mflo $t6
    
    # Display the average
    li $v0, 1
    move $a0, $t6
    syscall
    
    # Return to the main program
    jr $ra
# Call the performTask procedure
