    .data
string: .asciz "The result is %d\n"

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r5, #3
    mov r6, #2

    add r7, r5, r6, LSL #3 @ Logical Shift Left << -> *2 // Logical Shift Right >> -> 1/2
    @ r7 = r5 + r6 * 2^3

    ldr r0, =string
    mov r1, r7

    bl printf
    pop {pc}
