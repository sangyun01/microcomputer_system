    .data
string: .asciz "The result is %d, %d, and %d\n"
    .align @ not sorted the function

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r5, #10
    mov r6, #20
    mov r7, #30

    stmfd r13!, {r5-r7}
    ldmfd r13!, {r8-r10}

    ldr r0, =string
    mov r1, r8
    mov r2, r9
    mov r3, r10

    bl printf
    pop {pc}

    .end