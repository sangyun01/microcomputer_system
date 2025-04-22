    .data           @ data section
string: .asciz "The result is %08X(decimal : %d) \n"
                    @ use ascii, and the expression is 8-digit hexadecimal and decimal

    .text           @ code section
    .global main    @ main function global
    .extern printf  @ declare the printf 

main:               @ main function1
    push {lr}       @ stored the link register address using stack

    mov r5, #3      @ r5 = 3
    mov r6, #6      @ r6 =  6

    sub r7, r5, r6  @ r7 = r5 - r6 = 3 - 6 = - 3

    ldr r0, =string @ first address to string
    mov r1, r7  @ FFFF|FFFD
    mov r2, r7  @ -3

    bl printf   @ branch linked printf
    pop {pc}    @ pop return address from stack into PC to return from main
