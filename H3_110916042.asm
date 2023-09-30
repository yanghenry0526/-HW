;�@��:���v��
;�Ǹ�:110916042
;�ާ@����:DAS�BDAA���O��@
;�ŦX�з�
;	1. ���� DAS ���O�@�˥\�઺ procedure
;	2. ���� DAA ���O�@�˥\�઺ procedure
;---------------------------------------------------
;�۵�: 100
;�P�����q�������t��k

INCLUDE Irvine32.inc
.data

.code
main PROC
	mov eax, 0
	mov al, 48h		;���qP.75�Ĥ@�ӨҤl
	sub al, 35h
	call myDAS
	call DumpRegs	;�H DumpRegs ��ܵ��G
exit
main ENDP

myDAS PROC
	pushfd					;push EFLAGs Register into stack
	mov ecx, 0
	pop ecx
	mov ebx, 0
	mov bl, al
	and bl, 00001111b		;���al�᭱4��bit
	cmp bl, 9
	ja L1					
	test cl, 00010000b		;�W�T��AIf (AL(lo) > 9) OR (AuxCarry = 1)
	jz L2
	L1:						
		sub al, 6
		or cl, 00010000b
		jmp Second_if
	L2:						;AuxCarry = 0
		and cl, 11101111b

	Second_if:
	push ecx
	cmp al, 9Fh				;���al�e4bit(high bit)
	jbe L4
	L3:
		sub al, 60h
		popfd
		stc					;CF = 1
		jmp _exit
	L4:
		popfd
		jc L3;				���Carry flag
		clc					;CF = 0
	_exit:
		ret
myDAS ENDP

myDAA PROC
	pushfd					;push EFLAGs Register into stack
	mov ecx, 0
	pop ecx
	mov ebx, 0
	mov bl, al
	and bl, 00001111b		;���al�᭱4��bit
	cmp bl, 9
	ja L1					
	test cl, 00010000b		;�W�T��AIf (AL(lo) > 9) OR (AuxCarry = 1)
	jz L2					
	L1:
		add al, 6
		or cl, 00010000b
		jmp Second_if
	L2:						;AuxCarry = 0
		and cl, 11101111b		

	Second_if:
	push ecx
	cmp al, 9Fh				;���al�e4bit(high bit)
	jbe L4
	L3:
		add al, 60h
		popfd
		stc					;CF = 1
		jmp _exit
	L4:
		popfd
		jc L3				;���Carry flag
		clc					;CF = 0
	_exit:
		ret
myDAA ENDP
END main