    .data
string: .asciz "The result is %d, %d and %d\n"
        @ TABLE2의 값이 순차적으로 출력될 것이다.

    .align                  @ 정렬
TABLE1: .word 10, 20, 30
TABLE2: .word 0, 0, 0

    .text
    .global main
    .extern printf

main:
    push {lr}

    ldr r5, =TABLE1     @ r5에 TABLE1 주소 저장
    ldr r6, =TABLE2     @ r6에 TABLE2 주소 저장

    ldr r7, [r5]        @ r7에 주소 r5에 있는 값을 저장한다.
    str r7, [r6]        @ r7의 값을 주소 r6의 위치에 저장한다.

    ldr r7, [r5, #4]    @ r7에 주소 r5 + 4의 위치에 있는 값을 저장한다.
    str r7, [r6, #4]    @ r7의 값을 주소 r6 + 4의 위치에 저장한다.

    ldr r7, [r5, #8]    @ r7에 주소 r5 + 8의 위치에 있는 값을 저장한다.
    str r7, [r6, #8]    @ r7의 값을 주소 r6 + 8 위치에 저장한다.

    ldr r0, =string     
                        @ r6은 TABLE2의 주소이다.
    ldr r1, [r6]        @ r6의 주소에 있는 값을 호출한다.
    ldr r2, [r6, #4]    @ r6 + 4의 주소에 있는 값을 호출한다.
    ldr r3, [r6, #8]    @ r6 + 8의 주소에 있는 값을 호출한다.

    bl printf
    
    pop {pc}
    .end
