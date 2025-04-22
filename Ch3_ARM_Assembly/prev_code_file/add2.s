    .data   @ data section
x: .word 3  @ x에 int로 3저장
y: .word 7  @ y에 int로 7저장
z: .word 0  @ z에 int로 0저장
string: .asciz "The result is %d"

    .text           @ code section
    .global main
    .extern printf

main:
    push {lr}       @ r14 link register

    ldr r1, =x      @ r1에 x의 주소 저장
    ldr r5, [r1]    @ r5에 [r1의 주소]에 있는 값을 load

    ldr r2, =y      @ r2에 y의 주소 저장
    ldr r6, [r2]    @ r6에 [r2의 주소]에 있는 값을 load

    add r7, r5, r6  @ r7 = 3 + 7 하여 10의 값 저장

    ldr r3, =z      @ r3에 z의 주소 저장
    str r7, [r3]    @ r7의 값을 [r3의 주소]에 store - 주소 r3에 있는 값은 10이다.

    ldr r0, =string
    ldr r1, [r3]

    bl printf
    pop {pc}        @ program counter
    .end