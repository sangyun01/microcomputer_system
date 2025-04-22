    .data
string: .asciz "The result is %d\n"

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r5, #3  @ r5 = 3

    add r7, r5, #20 @ r7 = r5 + 20 = 23

    ldr r0, =string
    mov r1, r7

    bl printf
    pop {pc}
