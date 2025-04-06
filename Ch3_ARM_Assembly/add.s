    .data
string: .ascis "The result is %d\n"

    .text
    .global main
    .extern printf

main:
    push{lr}

    mov r5, #3
    mov r6, #7

    add r7, r5, r6

    ldr r0, =string
    mov r1, r7

    bl printf
    pop{pc}