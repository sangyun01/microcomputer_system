	.data				@ data section
	.equ NUM, 3			@ input 3 num each data
data1:	.word 0, 0, 0	@ input 1st
data2:	.word 0, 0, 0	@ input 2nd
data3: 	.word 0, 0, 0   @ output data

hex:		.asciz "%X"
dec:		.asciz "Data%d (%d). "
string1:	.asciz "Enter 6 numbers in hexadecimal (0~FFFFFFFF):\n"
string2:	.asciz "\t0x(%08X)(%08X)(%08X)\n +\t0x(%08X)(%08X)(%08X)\n"
string3:	.asciz " ----------------------------------------\n"
result:	.asciz " =\t0x(%08X)(%08X)(%08X)\n\n"  
                            @ %08X: an unsigned 32-bit integer (e.g. 0000FFFF)
                            @ in 8-digit uppercase hexadecimal, zero-padded on the left

	.text
	.global main
	.extern printf, scanf

main:
	push {lr}	

@ Give instruction
	ldr r0,=string1		@ print "Enter 6 numbers in hexadecimal (0~FFFFFFFF):\n"
	bl printf

@ Get input numbers
	mov r4,#NUM			@ r4 = 3
	mov r0,#1			@ r0 = 1
	ldr r5,=data1		@ 1st input data1
	bl getNumber		@ getNumber로 move

	mov r0,#2			@ r0 = 2
	ldr r5,=data2		@ 2nd input data2
	bl getNumber

@ Print the input values
	bl printValues

@ INSTRUNTION: Write code below to add two 96-bit data and print the result (+5pts)
@ INSTRUNTION: Use a loop (addBits) and a subroutine (checkCarry) (+5pts)

	ldr r1, =data1 		@ data1 주소 r1에 저장
	add r1, r1, #12		@ r1 = r1 + 12
	ldr r2, =data2		@ data2 주소 r2에 저장
	add r2, r2, #12		@ r2 = r2 + 12
	ldr r9, =data3		@ data3 주소 r3에 저장
	add r9, r9, #12		@ r9 = r9 + 12
	adds r4, r4, #0		@ CMPR 초기화(C=0)
	mov r5, #0			@ r5 = 0

addBits:
	ldr r3, [r1, #-4]!	@ r1+8 / r1+4 / r1의 주소에 있는 값을 r3에 저장
	ldr r7, [r2, #-4]!	@ r2+8 / r2+4 / r2의 주소에 있는 값을 r7에 저장

	bl checkCarry 		@ checkCarry / C 고려한 계산 진행

	str r3, [r9, #-4]!	@ r3의 값을 r1에 overwrite하여 값 저장

	subs r4, r4, #1		@ r4 = r4 - 1
	bne addBits			@ 2 -> 1 -> 0(break) / 3번 진행

@ result print function
	ldr r0, =result		@ " =\t0x(%08X)(%08X)(%08X)\n\n" 
	ldr r8, =data3		@ r8에 data3 주소 저장
	ldmia r8, {r1-r3}	@ r8(data3)에 있는 즉, data3의 값들을 r1 ~ r3에 저장함

	bl printf			@ print

	pop {pc}			@ 종료

@ Subroutines  (getNumber, printValues, checkCarry)
getNumber:	
	stmfd sp!, {r0-r12,lr}		@ using stack
	mov r11, r0					@ r11 = r0 = 1 / r11 = r0 = r2 
	getNumberLoop:				
		ldr r0,=dec				@ r0 = "Data%d (%d). "
		mov r1,r11				@ r1 = r11
		rsb r2,r4,#NUM			@ r2 = 3 - r4 / 1st -> 0, 2nd -> 1, 3rd -> 2
		add r2,r2,#1			@ r2 = r2 + 1 / 1st -> 1, 2nd -> 2, 3rd -> 3
		bl printf				@ Data1 (1). -> Data1 (2). -> Data1 (3) 
		ldr r0,=hex				@ hex로
		mov r1,r5				@ data 주소를 받아서
		bl scanf				@ 해당값을 저장하고
		add r5,r5,#4			@ r5 = r5 + 4
		subs r4,r4,#1			@ r4 = r4 - 1 / CPSR 저장하기 / 처음에 2 -> Z=0 / 1 -> Z=0 / 0 -> Z = 1
		bne	getNumberLoop		@ CPSR에서 Z = 1이면 탈출 / 결국 3개 받는다
	ldmfd sp!, {r0-r12,pc}		@ main r0~r15 복원

printValues:
    stmfd sp!, {r0-r12,lr}		@ using stack
	
	ldr r0, =string2			@ "\t0x(%08X)(%08X)(%08X)\n +\t0x(%08X)(%08X)(%08X)\n"
	ldr r12, =data1				@ 1st array
	ldmia r12, {r1-r3}			@ r1 -> [1->0] / r2 -> [1->1] / r3 -> [1->2]
	ldr r12, =data2				@ 2nd array
	ldmia r12, {r4-r6}			@ r4 -> [2->0] / r5 -> [2->1] / r6 -> [2->2]
	stmfd sp!, {r4-r6}        	@ r6 -> [2->2] / r5 -> [2->1] / r4 -> [2->0]
    bl printf                 	@ "\t0x(%08X)(%08X)(%08X)\n +\t0x(%08X)(%08X)(%08X)\n"
    add sp, sp, #12 			@ sp 복원
	ldr r0, =string3			@ print .asciz " ----------------------------------------\n"
	bl printf
    
	ldmfd sp!, {r0-r12,pc}		@ main r0~r15 복원

checkCarry:
    stmfd sp!, {r0-r2, r4, r6-r12, lr}  @ r3, r5, r6, r7 사용 예정

    mov   r6, #0
    adds  r3, r3, r5      @ 이전 carry 먼저 반영 → C 플래그 설정
    adc   r6, r6, #0      @ 첫 carry 발생 여부 → r6에 저장 (0 또는 1)

    mov   r5, #0
    adds  r3, r3, r7      @ 워드 덧셈 → C 플래그 설정
    adc   r5, r5, #0      @ 워드 덧셈으로 인한 carry → r5에 저장

    add   r5, r5, r6      @ 최종 carry = carry1 + carry2 (0~2까지 가능)

    ldmfd sp!, {r0-r2, r4, r6-r12, pc}

@ End of the program
	.end
