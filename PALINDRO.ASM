PUTCHAR MACRO CHAR
	MOV DL, CHAR
	MOV AH, 2
	INT 21H
ENDM

READLINE MACRO STRING
	MOV AH, 0AH          
	MOV DX, OFFSET STRING
	INT 21H
ENDM 

WRITELINE MACRO STRING
	MOV AH, 09H
	LEA DX, STRING
	INT 21H
ENDM

.MODEL SMALL
.DATA
    STRING DB 20 DUP('$')
    ENT DB 'Enter the string: $'
    NPALIN DB  10, 13, 'Entered string is not a Palindrome.$'
    PALIN DB 10, 13, 'Entered string is a Palindrome.$'
.CODE
    MOV AX, @DATA
    MOV DS, AX

	WRITELINE ENT
    READLINE STRING

	;GET POINTER TO LAST ELEMENT OF STRING IN SI
	CALL LAST

	MOV DI, OFFSET STRING
	ADD DI, 2

	SHR CX, 1
	COMPARE:
		
		MOV AL, [SI]
		MOV AH, [DI]
 		DEC SI
		INC DI
		CMP AL, AH
		JNE NOTP
		LOOP COMPARE

	WRITELINE PALIN
	JMP EOF
	NOTP:
		WRITELINE NPALIN
		JMP EOF

	LAST PROC NEAR
		MOV SI, OFFSET STRING
		MOV CL, STRING + 1
		MOV CH, 00
		ADD SI, CX
		INC SI
		RET
	LAST ENDP

	EOF: 
		MOV AH, 4CH
		INT 21H
		END