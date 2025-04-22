    .data
string: .asciz "The result is %d, %d, and %d\n"
    .align
TABLE1: .word 10, 20, 30
TABLE2: .word 0, 0, 0

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r4, #0  @ r4 = 0, r4 role the cnt

    ldr r5, =TABLE1
    ldr r6, =TABLE2

loop:
    ldr r7, [r5], #4    @ r7 = [r5]         // 1, 
                        @ r7 = [r5]         // 3, r5' = r5 + 4, r4 = 1
                        @ r7 = [r5 + 8]     // 5, r5'' = r5' + 4 = r5 + 8, r4 = 2
                                            // r5 = r5 + 12
    str r7, [r6], #4    @ [r6] = r7         // 2, r4 = 0
                        @ [r6 + 4] = r7     // 4, r6' = r6 + 4, r6 = 1
                        @ [r6 + 8] = r7     // 6, r6'' = r6' + 4 = r6 + 8, r4 = 2
                                            // r6 = r6 + 12

    add r4, r4, #1      @ r4 = r4 + 1
    cmp r4, #3          @ r4 - 3 
    bne loop            @ r4 - 3 <= 0, break, r4 > 0 branch loop

    sub r6, r6, 12      @ r6 = r6 - 12, reason r6 = r6 + 12. I'll use the printf

    ldr r0, =string
    ldr r1, [r6]
    ldr r2, [r6, #4]
    ldr r3, [r6, #8]

    bl printf
    pop {pc}
    .end
