    .data   @ data section
x: .word 3      @ int x = 3
y: .word 7      @ int y = 7
z: .word 0      @ int z = 0
string: .asciz "The result is %d"

    .text
    .global main
    .extern printf

main:
    push {lr}   @ lr = r14

    ldr r1, =x      @ bring the x address and store the address to r1
    ldr r5, [r1]    @ load the data at r1 and store r5

    ldr r2, =y
    ldr r6, [r2]

    add r7, r5, r6  @ r7 = 3 + 7

    ldr r3, =z      @ load at z address
    str r7, [r3]    @ store the r3's address r7 value

    ldr r0, =string
    ldr r1, [r3]    @ print 10

    bl printf
    pop {pc}
    .end
