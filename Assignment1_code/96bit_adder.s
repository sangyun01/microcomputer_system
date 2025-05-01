	.data				@ data section
	.equ NUM, 3			@ input 3 num each data
data1:	.word 0, 0, 0	@ input 1st
data2:	.word 0, 0, 0	@ input 2nd

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

	ldr r1, =data1
	ldr r2, =data2

addBits:
	ldr r3, [r1], #4
	ldr r7, [r2], #4

	adds r3, r3, r7
	bl checkCarry 

	str r3, [r1, #-4]

	subs r4, r4, #1
	bne addBits

@ result print function
	ldr r0, =result
	ldr r8, =data1
	ldmia r8, {r1-r3}

	bl printf

	pop {pc}	

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

checkCarry:	@ carry 발생하면 +1 해주기
	stmfd sp! {r0-r2, r4-r12, lr}
	
	adc r3, r3, #0
	
	ldmfd sp! {r0-r2, r4-r12, lr}

@ End of the program
	.end
