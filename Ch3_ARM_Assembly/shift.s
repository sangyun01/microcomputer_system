    .data
string: .asciz "The result is %d\n"

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r5, #3 @ r5 = 3
    mov r6, #2 @ r6 = 2

    add r7, r5, r6, LSL #3
    @ 구조 확인
    @ r7 = r5 + r6'
    @ r5 = 3
    @ r6' -> r6을 left로 3bit shift
    @ 3bit left shift => r6 << 3 -> 2 * 2^3 = 2 * 8 = 16
    @ final cal => r7 = 3 + 16

    ldr r0, =string
    mov r1, r7

    bl printf
    pop {pc}