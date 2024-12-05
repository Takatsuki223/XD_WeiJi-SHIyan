IO244	EQU	0230H	
IO273	EQU	0230H	

_STACK	SEGMENT	STACK
		DW	100	DUP(?)
_STACK	ENDS

_DATA	SEGMENT WORD	 PUBLIC 'DATA'
_DATA	ENDS

CODE		SEGMENT
ASSUME CS:CODE, DS:_DATA, SS:_STACK
START	PROC	 NEAR
		MOV	AX, _DATA
        	MOV DS, AX
INPUT:	
		MOV	DX, IO244
		IN	AL, DX
		CMP	AL, 0FFH	;������ȫΪ�͵�ƽ
		JZ Q1			;�����������ε���	
		CMP	AL, 0		;������ȫΪ�ߵ�ƽ
		JZ Q2			;�����������ε���
		MOV	DX, IO273
		NOT	AL			;AXȡ���͸�273,������Ӧ�Ķ�����
		OUT	DX, AL
		JMP	INPUT
Q1:
		MOV	AL, 7FH
		MOV	DX, IO273
R2L:
		CALL	 DELAY		;��ʱ
		OUT	DX, AL		;�͸�273,������Ӧ�Ķ�����
		ROL	AL, 1
		CMP	AL, 7FH
		JNE	R2L			;�����,˵��һ�ִ��������Ѿ����,������,�����ѭ��
		JMP	INPUT
		
Q2:
		MOV	AL, 0FEH
		MOV	DX, IO273
L2R:
		CALL	 DELAY
		OUT	DX, AL
		ROR	AL, 1
		CMP	AL, 0FEH
		JNE	L2R			;�����,˵��һ�ִ��������Ѿ����,������,�����ѭ��
		JMP	INPUT		;�������뿪��״̬
Delay 	PROC NEAR		;��ʱ�ӳ���
Delay1:	
XOR	CX,CX		;��һ����������CX����,��ѭ��һ��
		LOOP	$
		RET
Delay	ENDP
START	ENDP		
CODE		ENDS		
END		START
