WRITELINE MACRO VAR
	LEA DX, VAR
	MOV AH, 09
	INT 21H
ENDM

PUTCHAR MACRO CHAR
	MOV AH, 02H
	MOV DL, CHAR
	INT 21H
ENDM

DISPLAY MACRO VAR

	PUSH CX
	MOV AH, 0
	MOV AL, VAR
	MOV BX, 10     ;INITIALIZES DIVISOR
	MOV DX, 0000H    ;CLEARS DX
	MOV CX, 0000H    ;CLEARS CX
    
	;SPLITTING PROCESS STARTS HERE
	L1:
		MOV DX, 0000H    ;CLEARS DX DURING JUMP
		DIV BX      ;DIVIDES AX BY BX
		PUSH DX     ;PUSHES DX(REMAINDER) TO STACK
		INC CX      ;INCREMENTS COUNTER TO TRACK THE NUMBER OF DIGITS
		CMP AX, 0     ;CHECKS IF THERE IS STILL SOMETHING IN AX TO DIVIDE
		JNE L1     ;JUMPS IF AX IS NOT ZERO
    
	L2: 
		POP DX      ;POPS FROM STACK TO DX
		ADD DX, 3030H     ;CONVERTS TO IT'S ASCII EQUIVALENT
	
		MOV AH, 02H     
		INT 21H      ;CALLS DOS TO DISPLAY CHARACTER
		LOOP L2    ;LOOPS TILL CX EQUALS ZERO

	POP CX
ENDM


.MODEL SMALL
.DATA
	ARR DB 13, 52, 43, 23, 6, 54, 93
	N DB ($ - ARR)
	INIT DB 'Array before sorting: $'
	AFTER DB 10, 13, 'Array after sorting: $'
.CODE
    
    MOV AX, @DATA
    MOV DS, AX

	WRITELINE INIT
	CALL DISPLAYARR

	; Load CX with N - 1 
	MOV CL, N
	MOV CH, 0
	DEC CX

	MOV DX, CX
	DEC DX
	BUBBLESORT:

		MOV SI, 0
		OUTER:
			
			MOV DI, 0
			INNER:
				CMP DI, DX 
				JG INNERDONE
				INC DI
				
				MOV AL, ARR[DI - 1]
				MOV AH, ARR[DI]
				
				CMP AL, AH
				JG SWAP
				
			JMP INNER
			INNERDONE:
		DEC DX
		INC SI
		LOOP OUTER


	WRITELINE AFTER
	CALL DISPLAYARR
	MOV AH, 4CH
	INT 21H
	
	SWAP:
			MOV ARR[DI - 1], AH
			MOV ARR[DI], AL
			JMP INNER

	DISPLAYARR PROC NEAR

		MOV CL, N
		MOV CH, 0
		MOV SI, 0
		DISP:
			DISPLAY ARR[SI]
			PUTCHAR ' '
			INC SI
			LOOP DISP
		RET
	DISPLAYARR ENDP		
			
END
