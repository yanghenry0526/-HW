;姓名 : 楊宗翰
;學號 : 110916042
;操作說明:執行後,輸入一串數值,中間用空白隔開
;符合標準
;	1. 程式有意義且可以組譯執行
;	2. 支援整數排序
;	3. 將輸入的數字按照數值,由大到小排序
;------------------------------------------------
;自評: 100 (這東西好不直覺...) 拜託老師了
;------------------------------------------------


INCLUDE Irvine32.inc
 
.data
MAX = 100
val BYTE 0Ah
stringIn BYTE MAX + 1 DUP(20h)
array DWORD 10 DUP(0)
number DWORD 1

msg1 BYTE "請輸入要sort的數字：",0ah

 
.code
main PROC
	push OFFSET array
	push MAX
	push OFFSET stringIn
	call stringToArray
	push OFFSET array
	push number
	call bubbleSort
	push OFFSET array
	push number
	call print
	invoke ExitProcess, 0
main ENDP
 
;String To Integer array function
;edx: OFFSET of string
;ecx: string 存放最大值 = 100
;esi: OFFSET of integer array
;stack 內容:
;[ebp] : EBP		
;[ebp + 4] : Return Address	
;[ebp + 8] : OFFSET of string	
;[ebp + 12] : maximun volume of string		
;[ebp + 16] : OFFSET of integer array		

stringToArray PROC
	mov edx,OFFSET msg1
	call WriteString	;輸出 msg1
	push ebp
	mov ebp, esp
	mov edx, [ebp + 8]
	mov ecx, [ebp + 12]
	call ReadString
	mov esi, [ebp + 16]
	
	L1:			
		;掃描整個字串		
		cmp BYTE PTR [edx], 20h		;如果讀到空格 = 20h, jump L2
		je L2
		
		cmp BYTE PTR [edx], 0		;如果讀到字串結尾, jump L3
		je L3

		mov eax, [esi]
		mul val
		mov bl, BYTE PTR [edx]
		sub bl, 30h
		add al, bl
		mov [esi], eax
		inc edx
		loop L1
 
	L2:
		mov [esi], eax
		add esi, 4					;把array 的 Index 加 1, 把計數器加 1 
		inc edx						;把string的 Index 加 1, 把計數器加 1 
		mov eax, number
		inc eax
		mov number, eax
		jmp L1						;跳回L1，繼續掃描

	L3:
		mov esp, ebp
		pop ebp
		ret 12						;結束並跳離函式
stringToArray ENDP
 
;Bubble Sort function
;edx: 外層迴圈次數 
;ecx: 內層迴圈次數 
;esi: OFFSET of integer array
;stack內容:
;[ebp] : EBP				
;[ebp + 4] : Return Address		
;[ebp + 8] : 數字個數		
;[ebp + 12] : OFFSET of integer array		

bubbleSort PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp + 8]
	mov esi, [ebp + 12]
	dec edx
	L_out:								; bubble sort的外部迴圈, 計算掃描次數
		mov ecx, [ebp + 8]
		mov esi, [ebp + 12]
		
		L_in:							; bubble sort的內部迴圈, 跑過array內所有的元素
			mov eax, [esi]
			cmp eax, [esi + 4]			
			jnl common					; 如果當前元素大於下一個元素, 不執行swap, Index加1(直接跳到common)
			xchg eax, [esi + 4]
			mov [esi], eax
			common:
				add esi, 4				;Index 加 1
				loop L_in
		dec edx
		jnz L_out						;edx != 0(array內還有數字)，繼續loop
	mov esp, ebp
	pop ebp
	ret 8
bubbleSort ENDP
 
;print function
;ecx: 數字個數
;esi: OFFSET of integer array
;stack內容:
;[ebp] : EBP		
;[ebp + 4] : Return Address 		
;[ebp + 8] : 數字個數		
;[ebp + 12] : OFFSET of integer array	

print PROC

	push ebp
	mov ebp, esp
	mov esi, [ebp + 12]
	mov ecx, [ebp + 8]
	
	L1:									;掃描array的每一個數字,並輸出
		mov eax, [esi]
		call WriteDec
		mov eax, 20h					;輸出完數字加上空格(20h)
		call WriteChar
		add esi, 4
		loop L1
	mov esp, ebp
	pop ebp
	ret 8
print ENDP
END main