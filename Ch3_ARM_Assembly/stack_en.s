    .data
string: .asciz "The result is %d, %d, and %d\n"
    .align  @ not sort, because not exist the code

    .text
    .global main
    .extern printf

main:
    push {lr}   

    mov r5, #10 @ r5 = 10
    mov r6, #20 @ r6 = 20
    mov r7, #30 @ r7 = 30

    stmfd r13!, {r5-r7}     @ using stack pointer r13, stored r7 -> r6 -> r5, update r13 = r13 - 12
    ldmfd r13!, {r8-r10}    @ using stack pointer r13, pop r5 -> r6 -> r7, update r13 = r13 + 12

    ldr r0, =string
    mov r1, r8
    mov r2, r9
    mov r3, r10

    bl printf
    pop {pc}
    .end
