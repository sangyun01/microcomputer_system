    .data
num: .word 0
string1: .asciz "%d"
string2: .asciz "The input number is %d\n"

    .text
    .global main
    .extern printf
    .extern scanf

main:
    push {lr}

    ldr r0, =string1
    ldr r1, =num
    bl scanf

    ldr r0, =string2
    ldr r1, =num
    ldr r1, [r1]
    bl printf

    pop {pc}
