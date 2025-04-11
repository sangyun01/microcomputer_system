    .data
x: .word 3  @ x에 int로 3저장
y: .word 7  @ y에 int로 7저장
z: .word 0  @ z에 int로 0저장장

    .text
    .global main

main:
    push {lr}

    ldr r1, =x      @ r1에 x의 주소 저장
    ldr r5, [r1]    @ r5에 [r1의 주소]에 있는 값을 load

    ldr r2, =y      @ r2에 y의 주소 저장
    ldr r6, [r2]    @ r6에 [r2의 주소]에 있는 값을 load

    add r7, r5, r6  @ r7 = 3 + 7 하여 10의 값 저장

    ldr r3, =z      @ r3에 z의 주소 저장
    ldr r7, [r3]    @ r7에 [r3의 주소]에 있는 값을 load - 기존에 있던 10의 값을 overwrite함.

    pop {pc}
    .end