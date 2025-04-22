    .data
string: .asciz "The result is %d\n"

    .text
    .global main
    .extern printf

main:
    push {lr}

    mov r5, #3  @ r5에 3 저장

    add r7, r5, #20
    @ r7 = r5 + 20 -> 즉시 바로 레지스터 r5와 더하여 그 값을 r7에 더함

    ldr r0, =string
    mov r1, r7
    @ printf를 위해 값 이동

    bl printf
    pop {pc}