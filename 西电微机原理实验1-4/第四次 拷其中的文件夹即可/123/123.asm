COM_ADD EQU 0273H 
PA_ADD EQU 0270H 
PB_ADD EQU 0271H 
PC_ADD EQU 0272H 
_STACK SEGMENT STACK 
 DW 100 DUP(?) 
_STACK ENDS 
_DATA SEGMENT WORD PUBLIC 'DATA' 
_DATA ENDS 
CODE SEGMENT 
START PROC NEAR 
	ASSUME CS:CODE, DS:_DATA, SS:_STACK 
	MOV AX,_DATA  ; �����ݶε�ַ���ص�AX�Ĵ���
	MOV DS,AX ; �����ݶε�ַ���͸����ݶμĴ���DS
	NOP 
	MOV DX,COM_ADD ; �����ڵ�ַ���͸�DX�Ĵ���
	MOV AL,82H ; ����AL�Ĵ�����ֵΪ82H
	OUT DX,AL 
	
 
INPUT:	
		 ; �������
		MOV     AX, 0FFFFH 
		MOV	DX, PA_ADD
		OUT     DX, AX
		MOV	DX, PC_ADD
		OUT     DX, AX
		; �������
		MOV	DX, PB_ADD
		IN	al, DX
		mov    ah, 0
		
		; �ж�
		CMP	al, 0FFH ;ȫ1
		JZ low1	
		CMP	al, 0 ;ȫ0
		JZ high1			
		MOV	DX, PA_ADD	
		OUT	DX, al
		JMP	INPUT
; ��������ֵΪ0-7�����
low1:
		MOV	al, 7FH ; ����AL�Ĵ�����ֵΪ7FH
		MOV	DX, PA_ADD ; ������PA��ַ���͸�DX�Ĵ���
low2:	
		ROL	al, 1 ; ��AL�Ĵ�����ֵ��ѭ����λ1λ
		OUT	DX, al	
		CALL    Delay
		CMP	al, 7FH
		JNE	low2
		MOV    AX, 0FFFFH ; ��AX�Ĵ�����ֵ��Ϊ0xFFFF
		OUT     DX, AX	
; ��������ֵΪ8-15�����
low3:
		MOV	al, 7FH
		MOV	DX, PC_ADD
low4:
		ROL	al, 1
		OUT	DX, al	
		CALL    Delay
		CMP	al, 7FH
		JNE	low4		
		JMP	INPUT

; ��������ֵΪ15-8�����		
high1:
		MOV	al, 0FEH
		MOV	DX, PC_ADD
high2:	
		ROR	al, 1
		OUT	DX, al	
		CALL    Delay
		CMP	al, 0FEH
		JNE	high2
		MOV    AX, 0FFFFH
		OUT     DX, AX	
; ��������ֵΪ7-0�����
high3:
		MOV	al, 0FEH
		MOV	DX, PA_ADD
high4:
		ROR	al, 1
		OUT	DX, al	
		CALL    Delay
		CMP	al, 0FEH
		JNE	high4		
		JMP	INPUT




Delay 	PROC NEAR		
Delay1:	
XOR	CX,CX
		LOOP	$
		RET
Delay	ENDP


START ENDP 
CODE ENDS 
END START
