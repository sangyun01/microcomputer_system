    .data
string: .asciz "The result is %p (TABLE1) and %p (TABLE2)\n"

    .align
TABLE1: .word 10, 20, 30
TABLE2: .word 0, 0, 0

    .text
    .global main
    .extern printf

main:
    push {lr}

    ldr r5, =TABLE1
    ldr r6, =TABLE2

    ldr r0, =string

    mov r1, r5
    mov r2, r6

    bl printf
    pop {pc}
