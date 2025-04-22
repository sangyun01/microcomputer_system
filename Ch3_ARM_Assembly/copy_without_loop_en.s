    .data
string: .asciz "The result is %d, %d and %d\n"
        @ it amplict using the register to printf r1, r2, r3

    .align @ if not sort the TABLE1 then occur error, so using .align / like .word k -> error
TABLE1: .word 10, 20, 30
TABLE2: .word 0, 0, 0

    .text               @ omit
    .global main
    .extern printf

main:
    push {lr}

    ldr r5, =TABLE1     @ r5 is TABLE1 first address
    ldr r6, =TABLE2

    ldr r7, [r5]        @ r7 is TABLE1 first element, because r5 is TABLE1 first address // r5의 값이 r7 저장
    str r7, [r6]        @ store the element value r7, where address r6 // r7의 값이 주소 r6의 처음 값으로 저장 -> TABLE2: .word 10, 0, 0

    ldr r7, [r5, #4]    @ r7 is TABLE1 second element, because r5 + 4
    str r7, [r6, #4]    @ store the element value r7, where address r6 // r7의 값이 주소 r6의 두 번째 값으로 저장 -> TABLE2: .word 10, 20, 0

    ldr r7, [r5, #8]    @ r7 is TABLE1 last element, because r5 + 8
    str r7, [r6, #8]    @ store the element value r7, where address r6 // r7의 값이 주소 r6의 세 번째 값으로 저장 -> TABLE2: .word 10, 20, 30

    ldr r0, =string
    ldr r1, [r6]        @ 10
    ldr r2, [r6, #4]    @ 20
    ldr r3, [r6, #8]    @ 30

    bl printf

    pop {pc}
    .end
