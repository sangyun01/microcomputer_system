    .data
string: .asciz "The result is %08X(decimal : %d) \n"
        @16진수로 표현하기 위해서 X를 사용, 8글자를 호출하기 위해 08 사용
        @ 10진수의 값 %d도 추가 / 계산결과는 FFFF/FFFD -> -3이 나올것이다.

    .text
    .global main
    .extern printf

    push {lr}

    mov r5, #3
    mov r6, #6

    sub r7, r5, r6  @ r7 = r5 - r6 = 3 - 6 = -3을 저장

    ldr r0, =string

    mov r1, r7 @r1에 r7값(-3)을 저장 -> 16진수로 표현
    mov r2, r7 @r2에 r7값(-3)을 저장 -> 10진수로 표현

    bl printf
    pop{pc}