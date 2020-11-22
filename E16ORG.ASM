assume cs:code
code segment
start:	mov ax,cs
	mov ds,ax
	mov si,offset setscreen
	mov ax,0
	mov es,ax
	mov di,204h
	mov cx,offset setscreenend-offset setscreen
	cld
	rep movsb

	mov ax,0
	mov es,ax

	;将原来的例程的入口地址保存在0:200H处,共2个字单元。
	push es:[7cH*4] ;将向量表中7ch号ip压栈  
	pop es:[200H]   ;弹栈到0:200H处
	push es:[7cH*4+2]   ;将向量表中7ch号cs压栈
	pop es:[202H]   ;弹栈到0:202H处
	;设置中断向量表，使7ch条目中断向量指向0000:204H

	cli
	mov word ptr es:[7ch*4],204h
	mov word ptr es:[7ch*4+2],0
	sti

	mov ax,4c00h
	int 21h

	org 204h ; 从0:204h重新计算标号

setscreen:	jmp short set
table	dw sub1,sub2,sub3,sub4
set:	push bx

	cmp ah,3 ; 判断功能号是否大于3
	ja sret
	mov bl,ah
	mov bh,0
	add bx,bx ; 根据ah中的功能号计算对应的子程序在table表中的偏移
	
	call word ptr table[bx]

sret:	pop bx
	iret


; 清屏
sub1:	push bx
	push cx
	push es
	mov bx,0b800h
	mov es,bx
	mov bx,0
	mov cx,2000
sub1s:	mov byte ptr es:[bx],' '
	add bx,2
	loop sub1s
	pop es
	pop cx
	pop bx
	ret

; 设置前景色
sub2:	push bx
	push cx
	push es

	mov bx,0b800h
	mov es,bx
	mov bx,1
	mov cx,2000
sub2s:	and byte ptr es:[bx],11111000b ; 重置之前的前景色
	or es:[bx],al ; 按al为1的bit位置，设置前景色相应的bit为1
	add bx,2
	loop sub2s

	pop es
	pop cx
	pop bx
	ret

; 设置背景色
sub3:	push bx
	push cx
	push es
	mov cl,4
	shl al,cl ; 移动后背景色的位置
	mov bx,0b800h
	mov es,bx
	mov bx,1
	mov cx,2000
sub3s:	and byte ptr es:[bx],10001111b ; 重置之前的前景色
	or es:[bx],al ; 按al为1的bit位置，设置前景色相应的bit为1
	add bx,2
	loop sub3s
	pop es
	pop cx
	pop bx
	ret

sub4:	push cx
	push si
	push di
	push es
	push ds

	mov si,0b800h
	mov es,si
	mov ds,si
	mov si,160 ; ds:si 指向第n+1行
	mov di,0 ; es:di 指向第n行
	cld
	mov cx,24

sub4s:	push cx
	mov cx,160
	rep movsb ; 复制
	pop cx
	loop sub4s

	mov cx,80
	mov si,0
sub4s1:	mov byte ptr [160*24+si],' ' ; 最后一行清空
	add si,2
	loop sub4s1

	pop ds
	pop es
	pop di
	pop si
	pop cx
	ret

setscreenend: nop

code ends
end start
