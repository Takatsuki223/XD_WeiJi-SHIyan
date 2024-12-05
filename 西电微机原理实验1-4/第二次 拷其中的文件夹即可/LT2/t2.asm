STACK1 SEGMENT STACK
	DB 128 DUP(0)
STACK1 ENDS

DATA SEGMENT
    TISHIINFO           DB 'Please input a number:',0AH,0DH,'$'
    STRING              DB 0AH,0DH,'String:$'
    INPUT               DB 20H
    DB 100 DUP('$')
    RESULT              DB 'Binary:$'
    ERRORINFO           DB 'Please input again:',0AH,0DH,'$'
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK1

START:
    MOV AX, STACK1
    MOV SS, AX
    MOV AX, DATA
    MOV DS, AX
    MOV DX, OFFSET TISHIINFO
    MOV AH, 09H
    INT 21H
    MOV BX, 0

READ:
    MOV DX, OFFSET STRING
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET INPUT
    MOV AH, 0AH
    MOV AL, 00H
    INT 21H
    MOV BX, OFFSET INPUT+1
    MOV CX, [BX]
    MOV CH, 0
    MOV DX, OFFSET INPUT+2
    MOV AL, [BX+1]
    CMP AL, 'q'
    JE EXIT
    CMP AL, 'Q'
    JE EXIT

    CALL NEW
    CALL BINARY
    PUSH AX
    MOV DX, OFFSET RESULT
    MOV AH, 09H
    INT 21H
    POP AX
    CALL DISPBIN
    JMP READ

EXIT:
     MOV AH, 4CH
     INT 21H

BINARY PROC
    PUSH BX
    PUSH SI
    PUSH CX
    PUSH DX
    MOV BX, 0
    MOV SI, DX
    MOV AH, 0
    MOV AL, [SI]
    SUB AX, 30H
    CMP AX, 9
    JA OVERERR
    CMP CX, 1H
    JE BINPROCESS
    MOV DX, 10
    DEC CX
LOOPFORBIN:
    INC SI
    MOV DX, 10
    MUL DX
    MOV BL, [SI]
    SUB BL, 30H
    CMP BL, 9
    JA OVERERR
    ADD AX, BX
    LOOP LOOPFORBIN
    JMP BINPROCESS

OVERERR:
    POP DX
    POP CX
    PUSH CX
    PUSH DX
    CALL COUNT
    CALL NEW
    MOV DX, OFFSET ERRORINFO
    MOV AH, 09H
    INT 21H
    POP DX
    POP CX
    POP SI
    POP BX
    JMP READ

BINPROCESS:
    POP DX
    POP CX
    POP SI
    POP BX
    RET
BINARY ENDP

COUNT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV SI, DX
    MOV AX, 0
CHECK:
    MOV BL, [SI]
    INC SI
    CMP BL, 30H
    JB NOTNUM
    CMP BL, 39H
    JA NOTNUM
    INC AX
NOTNUM:
    LOOP CHECK
    ADD AX, 30H
    MOV DX, AX
    MOV AH, 02H
    INT 21H
    POP DX
    POP CX
    POP BX
    POP AX
    RET
COUNT ENDP

DISPBIN PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV BX, AX
    MOV CX, 16     ; Display 16 bits (maximum size for 16-bit integer)
L1:
    PUSH CX
    MOV CL, 1
    ROL BX, CL
    MOV DL, BL
    AND DL, 01H    ; Extract the lowest bit
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    POP CX
    LOOP L1
    POP DX
    POP CX
    POP BX
    POP AX
DISPBIN ENDP

NEW PROC
    PUSH AX
    PUSH DX
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    MOV DL, 0DH
    INT 21H
    POP DX
    POP AX
    RET
NEW ENDP

CODE ENDS
END START

