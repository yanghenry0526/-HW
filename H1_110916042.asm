;�m�W : ���v��
;�Ǹ� : 110916042
;�ާ@����:�����,��J�@��ƭ�,�����Ϊťչj�}
;�ŦX�з�
;	1. �{�����N�q�B�i�H��Ķ����
;	2. �䴩��ƱƧ�
;	3. �N��J���Ʀr���Ӽƭ�,�Ѥj��p�Ƨ�
;------------------------------------------------
;�۵�: 100 (�o�F��n����ı...) ���U�Ѯv�F
;------------------------------------------------


INCLUDE Irvine32.inc
 
.data
MAX = 100
val BYTE 0Ah
stringIn BYTE MAX + 1 DUP(20h)
array DWORD 10 DUP(0)
number DWORD 1

msg1 BYTE "�п�J�nsort���Ʀr�G",0ah

 
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
;ecx: string �s��̤j�� = 100
;esi: OFFSET of integer array
;stack ���e:
;[ebp] : EBP		
;[ebp + 4] : Return Address	
;[ebp + 8] : OFFSET of string	
;[ebp + 12] : maximun volume of string		
;[ebp + 16] : OFFSET of integer array		

stringToArray PROC
	mov edx,OFFSET msg1
	call WriteString	;��X msg1
	push ebp
	mov ebp, esp
	mov edx, [ebp + 8]
	mov ecx, [ebp + 12]
	call ReadString
	mov esi, [ebp + 16]
	
	L1:			
		;���y��Ӧr��		
		cmp BYTE PTR [edx], 20h		;�p�GŪ��Ů� = 20h, jump L2
		je L2
		
		cmp BYTE PTR [edx], 0		;�p�GŪ��r�굲��, jump L3
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
		add esi, 4					;��array �� Index �[ 1, ��p�ƾ��[ 1 
		inc edx						;��string�� Index �[ 1, ��p�ƾ��[ 1 
		mov eax, number
		inc eax
		mov number, eax
		jmp L1						;���^L1�A�~�򱽴y

	L3:
		mov esp, ebp
		pop ebp
		ret 12						;�����ø����禡
stringToArray ENDP
 
;Bubble Sort function
;edx: �~�h�j�馸�� 
;ecx: ���h�j�馸�� 
;esi: OFFSET of integer array
;stack���e:
;[ebp] : EBP				
;[ebp + 4] : Return Address		
;[ebp + 8] : �Ʀr�Ӽ�		
;[ebp + 12] : OFFSET of integer array		

bubbleSort PROC
	push ebp
	mov ebp, esp
	mov edx, [ebp + 8]
	mov esi, [ebp + 12]
	dec edx
	L_out:								; bubble sort���~���j��, �p�ⱽ�y����
		mov ecx, [ebp + 8]
		mov esi, [ebp + 12]
		
		L_in:							; bubble sort�������j��, �]�Larray���Ҧ�������
			mov eax, [esi]
			cmp eax, [esi + 4]			
			jnl common					; �p�G��e�����j��U�@�Ӥ���, ������swap, Index�[1(��������common)
			xchg eax, [esi + 4]
			mov [esi], eax
			common:
				add esi, 4				;Index �[ 1
				loop L_in
		dec edx
		jnz L_out						;edx != 0(array���٦��Ʀr)�A�~��loop
	mov esp, ebp
	pop ebp
	ret 8
bubbleSort ENDP
 
;print function
;ecx: �Ʀr�Ӽ�
;esi: OFFSET of integer array
;stack���e:
;[ebp] : EBP		
;[ebp + 4] : Return Address 		
;[ebp + 8] : �Ʀr�Ӽ�		
;[ebp + 12] : OFFSET of integer array	

print PROC

	push ebp
	mov ebp, esp
	mov esi, [ebp + 12]
	mov ecx, [ebp + 8]
	
	L1:									;���yarray���C�@�ӼƦr,�ÿ�X
		mov eax, [esi]
		call WriteDec
		mov eax, 20h					;��X���Ʀr�[�W�Ů�(20h)
		call WriteChar
		add esi, 4
		loop L1
	mov esp, ebp
	pop ebp
	ret 8
print ENDP
END main