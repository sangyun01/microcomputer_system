    .data
string: .ascis "The result is %08X(decimal : %d) \n"

    .text
    .global main
    .extern printf

    push {lr}

    mov r5, #3
    mov r6, #6

    sub r7, r5, r6

    ldr r0, =string

    mov r1, r7
    mov r2, r7

    bl printf
    pop{pc}