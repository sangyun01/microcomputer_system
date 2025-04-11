    .data
string: .asciz "The result is %p (TABLE1) and %p (TABLE2)\n"
@ %p -> 주소값 출력
@ %0x와 동일한 형태로 출력된다 - 둘다 16진수이므로

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

    bl printf       @ r1과 r2의 주소가 출력된다.
                    @ if r1의 주소가 0x21054라고 하자
                    @ word는 3개를 받았다. -> 4byte * 3 = 12byte
                    @ 0x21054 + 12 => 0x21060이 된다.
                    @ 따라서 r2의 시작주소는 0x21060이다.
    pop {pc}