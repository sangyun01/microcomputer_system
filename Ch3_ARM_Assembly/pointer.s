    .data
string: .asciz "The result is %p (TABLE1) and %p (TABLE2)\n"
@ %p -> 주소값 출력력
    .align                      @ 데이터 정렬
TABLE1: .word 10, 20, 30        @ TABLE1의 배열 [10, 20, 30]
TABLE2: .word 0, 0, 0           @ TABLE2의 배열 [0, 0, 0]

    .text
    .global main
    .extern printf

main:
    push {lr}

    ldr r5, =TABLE1 @ r5에 TABLE1 배열의 주소 저장
    ldr r6, =TABLE2 @ r6에 TABLE2 배열의 주소 저장

    ldr r0, =string @ string의 주소 r0에 저장

    mov r1, r5      @ r1에 r5값 저장            
    mov r2, r6      @ r2에 r6값 저장

    bl printf
    pop {pc}