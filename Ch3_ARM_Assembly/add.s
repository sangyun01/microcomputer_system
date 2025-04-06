    .data   @data area(section) 
string: .asciz "The result is %d\n" 
@string은 변수 type이 아니라 label을 선언한 것이다.
@.asciz가 c에서의 string형 type 문자열 저장과 거의 유사하다. 자동으로 \n을 붙여줌.
@=string을 하면 문자열 전체를 가져오는 것이 아니라, T의 주소만 가져온다.
@ -> 이유로는 전체를 가져오게 되면 32bit를 초과할 수 있기에

    .text   @code area
    .global main    @main함수를 전역으로 둔다.
    .extern printf  @printf를 외부에서 가져오기 위해서 선언한다. c언어 I/O

main:       @main함수 시작
    push{lr}    @link register(r14)에 current address를 저장한다.

    mov r5, #3  @r5에 immediate값 3을 저장한다. immediate value이라서, memory와 register를 거치지 않아 속도가 빠르다. 
    mov r6, #7  @r6에 immediate값 7을 저장한다.

    add r7, r5, r6  @ r7 = r5 + r6의 값을 r7에 저장한다.
                    @ add -> opcode / r5, r6 -> source register / r7 -> destination register
                    @ ARM은 3-address instuctions

    ldr r0, =string @ 2번 line에 있는 "T"의 주소만 r0에 "주소값"을 저장한다. 값이 아님
    mov r1, r7      @ r7의 값을 r1에 저장한다.
                    @ r1로 data value를 이동하는 이유는, printf는 r0 ~ r3의 값을 가져올 수 있기에
                    @ r7에 두고 사용도 가능하지만, 사용하기 위해서는 stack의 개념이 필요하다.

    bl printf       @ 외부의 printf함수를 호출하여 사용하며, printf도 함수의 개념이기에 lr에 주소를 저장한다.
    pop{pc}         @ program counter에 이전에 있었던 주소로 다시 돌아간다. 함수의 기본 작동 방식이다.