;姓名 : 楊宗翰
;學號 : 110916042
;操作說明 : 輸入中序運算式轉換成後序運算式
;符合標準
;	1. 支援括號
;	2. 運算子包含 +,-,*,/
;--------------------------------------------
;自評分數 : 100


INCLUDE Irvine32.inc
.data
MAX = 100
stringIn BYTE MAX + 1 DUP(20h)
msg1 BYTE  "Input the Infix formula : ",0h

.code
main PROC
	push MAX
	push OFFSET stringIn
	call Infix_to_Postfix
exit
main ENDP


Infix_to_Postfix PROC
	mov edx,OFFSET msg1
	call WriteString		;msg1輸出

	push ebp		;存入stack
	mov ebp, esp
	mov edx, [ebp + 8]
	mov ecx, [ebp + 12]
	call ReadString			;讀取輸入
	mov esi, OFFSET stringIn
	push '#'
	L1:
		mov eax, 0
		mov al, [esi]
		cmp al, 0
		je L2
		cmp al, '('		;判斷左括號'('
		je L3
		cmp al, ')'		;判斷右括號')'
		je L4
		call Operator_Priority		;呼叫Operator_Priority
		cmp ebx, -2		;判斷operand
		jne L5			;Operand直接輸出, 讀取下一個字元
		call WriteChar	;將Operand輸出
		inc esi
		jmp L1
	;End of the string, check whether the stack is empty. 

	L2:			
		cmp BYTE PTR [esp], '#'
		je _exit
		pop eax
		call WriteChar
		jmp L2
	
	L3:			;Encounter with left parenthese, just push it into stack.
		push [esi]
		inc esi
		jmp L1
	
	L4:			;Encounter with right parenthese, pop the operator until the left parenthese first encountered is popped.
		mov eax, [esp]
		cmp al, '('
		je _pop_left_parenthese
		mov eax, 0
		pop eax
		call WriteChar		;output the operator
		jmp L4
		
		_pop_left_parenthese:
			pop edx
			mov edx, 0
			inc esi			;位置加一加一
			jmp L1
	
	L5:		;Encounter with operator, compare the priotity with the top operator in the stack
		mov ecx, 0
		mov ecx, ebx
		mov al, BYTE PTR [esp]
		call Operator_Priority
		cmp ebx, ecx
		jge _pop_until_less  ;LeftOp >= RightOp
		push [esi]
		inc esi
		jmp L1
		_pop_until_less:
			call WriteChar
			pop edx
			mov edx, 0
			mov al, BYTE PTR [esp]
			call Operator_Priority
			cmp ebx, ecx
			jge _pop_until_less
			push [esi]
			inc esi
			jmp L1
	_exit:
		pop eax
		mov eax, 0
		mov esp, ebp
		pop ebp
		ret 8
Infix_to_Postfix ENDP

;Compare operator's piority
;(1)operand : ebx = 本身的piority
;(2)operator : ebx = -2

Operator_Priority PROC
	cmp eax, '#'
	je L1
	cmp eax, '('
	je L2
	cmp eax, ')'
	je L2
	cmp eax, '+'
	je L3
	cmp eax, '-'
	je L3
	cmp eax, '*'
	je L4
	cmp eax, '/'
	je L4
	mov ebx, -2
	jmp _exit
	L1:
		mov ebx, -1
		jmp _exit
	L2:
		mov ebx, 0 
		jmp _exit
	L3:
		mov ebx, 1
		jmp _exit
	L4:
		mov ebx, 2
		jmp _exit
	_exit:
		ret
Operator_Priority ENDP

END main
