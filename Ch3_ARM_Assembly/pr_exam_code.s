@ goal of the code
@ user input the 5 integer data
@ sum the integer data using subroutine loop
@ print the sum result

    .data
    .equ SIZE, 5
string1: .asciz "input the number"
string2: .asciz "%d"
string3: .asciz "reset of the sum"
string4: .asciz "%d"
arr: .SPACE SIZE*4

    .text
    .global main
    .extern printf
    .extern scanf

main:
    push {lf}

    ldr r0, =string1
    bl printf

    mov r4, #0
    ldr r5, =arr

scanfloop:
    ldr r0, =string2
    mov r1, r5
    bl scanf

    add r4, r4, #1
    add r5, r5, #4

    cmp r4, SIZE
    blt scanfloop

    @ main function again start
    
    mov r4, #0
    mov r7, #0
    ldr r5, =arr

sumloop:

    ldr r6, [r5], #4
    add r7, r7, r6

    add r4, r4, #1

    cmp r4, SIZE
    blt sumloop

    ldr r0, =string3
    bl printf
    
    ldr r0, =string4
    mov r1, r7

    bl printf

    pop {pc}
    .end