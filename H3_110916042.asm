;作者:楊宗翰
;學號:110916042
;操作說明:DAS、DAA指令實作
;符合標準
;	1. 完成 DAS 指令一樣功能的 procedure
;	2. 完成 DAA 指令一樣功能的 procedure
;---------------------------------------------------
;自評: 100
;感謝講義內有附演算法

INCLUDE Irvine32.inc
.data

.code
main PROC
	mov eax, 0
	mov al, 48h		;講義P.75第一個例子
	sub al, 35h
	call myDAS
	call DumpRegs	;以 DumpRegs 顯示結果
exit
main ENDP

myDAS PROC
	pushfd					;push EFLAGs Register into stack
	mov ecx, 0
	pop ecx
	mov ebx, 0
	mov bl, al
	and bl, 00001111b		;比較al後面4個bit
	cmp bl, 9
	ja L1					
	test cl, 00010000b		;上三行，If (AL(lo) > 9) OR (AuxCarry = 1)
	jz L2
	L1:						
		sub al, 6
		or cl, 00010000b
		jmp Second_if
	L2:						;AuxCarry = 0
		and cl, 11101111b

	Second_if:
	push ecx
	cmp al, 9Fh				;比較al前4bit(high bit)
	jbe L4
	L3:
		sub al, 60h
		popfd
		stc					;CF = 1
		jmp _exit
	L4:
		popfd
		jc L3;				比較Carry flag
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
	and bl, 00001111b		;比較al後面4個bit
	cmp bl, 9
	ja L1					
	test cl, 00010000b		;上三行，If (AL(lo) > 9) OR (AuxCarry = 1)
	jz L2					
	L1:
		add al, 6
		or cl, 00010000b
		jmp Second_if
	L2:						;AuxCarry = 0
		and cl, 11101111b		

	Second_if:
	push ecx
	cmp al, 9Fh				;比較al前4bit(high bit)
	jbe L4
	L3:
		add al, 60h
		popfd
		stc					;CF = 1
		jmp _exit
	L4:
		popfd
		jc L3				;比較Carry flag
		clc					;CF = 0
	_exit:
		ret
myDAA ENDP
END main